#!/usr/bin/env python3

import subprocess
import re
import time
import sys

def call(args):
    return '\n'.join(subprocess.check_output(args).decode().splitlines())

def get_statuses(args):
    ids = call(["docker-compose"] + args + ["ps", "-q"]).splitlines()
    status_list = [tuple(x.split(",")) for x in call(["docker", "ps", "--all", "--format", "{{.ID}},{{.Status}}"]).splitlines()]
    statuses = {}
    for id in ids:
        status = None
        for s in status_list:
            if id.find(s[0]) == 0:
                status = s[1]
                break
        if status is None:
            raise Exception("Could not find status for container id %s" % id)
        statuses[id] = status
    return statuses

def convert_status(s):
    res = re.search(r"^([^\s]+)[^\(]*(?:\((.*)\))?$", s)
    if res is None:
        raise Exception("Unknown status format %s" % s)
    if res[1] == "Up":
        if res[2] == "health: starting":
            return None
        elif res[2] == "healthy":
            return True
        elif res[2] == "unhealthy":
            return False
        elif res[2] is None:
            return True
        else:
            raise Exception("Unknown status format %s" % s)
    else:
        return False

def get_converted_statuses(args):
    return dict([(k, convert_status(v)) for k, v in get_statuses(args).items()])

while True:
    statuses = get_converted_statuses(sys.argv[1:])
    result = True
    for k, v in statuses.items():
        if v is None:
            result = None
            break
        elif v:
            continue
        else: # not v
            result = False
            break

    if v:
        print("All processes up and running")
        exit(0)
    elif v is False:
        print("Some processes failed")
        exit(-1)

    time.sleep(1)

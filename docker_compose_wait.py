#!/usr/bin/env python3

from __future__ import division, absolute_import, print_function, unicode_literals

import subprocess
import re
import time
import sys
import argparse

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
    res = re.search(r"^([^\s]+)[^\(]*(?:\((.*)\).*)?$", s)
    if res is None:
        raise Exception("Unknown status format %s" % s)
    if res.group(1) == "Up":
        if res.group(2) == "health: starting":
            return None
        elif res.group(2) == "healthy":
            return True
        elif res.group(2) == "unhealthy":
            return False
        elif res.group(2) is None:
            return True
        else:
            raise Exception("Unknown status format %s" % s)
    else:
        return False

def get_converted_statuses(args):
    return dict([(k, convert_status(v)) for k, v in get_statuses(args).items()])


def main():
    parser = argparse.ArgumentParser(
        description='Wait until all services in a docker-compose file are healthy. Options are forwarded to docker-compose.',
        usage='docker-compose-wait.py [options]'
        )

    args, unknown = parser.parse_known_args()

    while True:
        statuses = get_converted_statuses(unknown)
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

        if result:
            print("All processes up and running")
            exit(0)
        elif result is False:
            print("Some processes failed")
            exit(-1)

        time.sleep(1)

if __name__ == "__main__":
    # execute only if run as a script
    main()

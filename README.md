
# docker-compose-wait

[![Build Status](https://travis-ci.org/nicolas-van/docker-compose-wait.svg?branch=master)](https://travis-ci.org/nicolas-van/docker-compose-wait)
[![PyPI](https://img.shields.io/pypi/v/docker-compose-wait.svg)](https://pypi.org/project/docker-compose-wait/)


Some useful script to wait until all services declared in a docker-compose file are up and running.

This script uses the health check mechanism provided since Docker 1.12. If your services have a configured health check, after making a `docker-compose up -d` you can simply call this script to have it wait until all your services health statuses are fixed. If they are all `healthy` it will return `0` if any of them is `unhealthy` (or `Down`) it will return -1.

This script can be useful, as example, in Continuous Integration or other situations when you just want to wait until a stack is deployed before performing other actions.

*Please note this script does not do anything about dependencies startup order. See the [official documentation](https://docs.docker.com/compose/startup-order/) for that problem.*

## Installation

```
pip install docker-compose-wait
```

This utility requires Python 2.7 or Python >= 3.3. It also supports `docker-compose` from version 1.10.

## Usage

```
usage: docker-compose-wait.py [options]

Wait until all services in a docker-compose file are healthy. Options are
forwarded to docker-compose.

optional arguments:
  -h, --help            show this help message and exit
  -f FILE, --file FILE  Specify an alternate compose file (default: docker-
                        compose.yml)
  -p PROJECT_NAME, --project-name PROJECT_NAME
                        Specify an alternate project name (default: directory
                        name)
  -w, --wait            Wait for all the processes to stabilize before exit
                        (default behavior is to exit as soon as any of the
                        processes is unhealthy)
  -t TIMEOUT, --timeout TIMEOUT
                        Max amount of time during which this command will run
                        (expressed using the same format than in docker-
                        compose.yml files, example: 5s, 10m,... ). If there is
                        a timeout this command will exit returning 1.
                        (default: wait for an infinite amount of time)
```

Basically it can be as simple as:

```
docker-compose-wait
```

`docker-compose-wait` behaves like a `docker-compose` sub-command. It will forward the usual `docker-compose` command-line arguments. The above command will work fine if you previously ran `docker-compose up -d` by referencing the standard `docker-compose.yml` file. If you are using other files for your `docker-compose` configuration just use:

```
docker-compose-wait -f <path_to_yaml_file> -f <path_to_other_yaml_file> ...
```

## License

[See the license file](https://github.com/nicolas-van/docker-compose-wait/blob/master/LICENSE.md).

## Contribution

[See the contribution guide](https://github.com/nicolas-van/docker-compose-wait/blob/master/CONTRIBUTING.md).

#!/usr/bin/env bats

@test "simple" {
  dc=tests/docker-compose-simple.yml
  docker-compose -f $dc up -d
  ./docker-compose-wait.py -f $dc
  docker-compose -f $dc down
}

@test "fail" {
  dc=tests/docker-compose-fail.yml
  docker-compose -f $dc up -d
  ./docker-compose-wait.py -f $dc && false || true
  docker-compose -f $dc down
}

@test "no healthcheck" {
  dc=tests/docker-compose-no-healthcheck.yml
  docker-compose -f $dc up -d
  ./docker-compose-wait.py -f $dc
  docker-compose -f $dc down
}

@test "down" {
  dc=tests/docker-compose-down.yml
  docker-compose -f $dc up -d
  ./docker-compose-wait.py -f $dc && false || true
  docker-compose -f $dc down
}

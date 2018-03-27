#!/usr/bin/env bats

@test "simple" {
  dc=tests/docker-compose-simple.yml
  docker-compose -f $dc up -d
  run ./docker-compose-wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "fail" {
  dc=tests/docker-compose-fail.yml
  docker-compose -f $dc up -d
  run ./docker-compose-wait.py -f $dc
  [ "$status" -eq 255 ]
  docker-compose -f $dc down
}

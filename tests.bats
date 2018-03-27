#!/usr/bin/env bats

@test "simple" {
  docker-compose -f tests/docker-compose-simple.yml up -d
  ./docker-compose-wait.py -f tests/docker-compose-simple.yml
  docker-compose -f tests/docker-compose-simple.yml down
}

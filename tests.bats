@test "simple" {
  dc=tests/docker-compose-simple.yml
  docker-compose -f $dc up -d
  run ./docker_compose_wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "fail" {
  dc=tests/docker-compose-fail.yml
  docker-compose -f $dc up -d
  run ./docker_compose_wait.py -f $dc
  [ "$status" -eq 255 ]
  docker-compose -f $dc down
}

@test "no healthcheck" {
  dc=tests/docker-compose-no-healthcheck.yml
  docker-compose -f $dc up -d
  run ./docker_compose_wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "down" {
  dc=tests/docker-compose-down.yml
  docker-compose -f $dc up -d
  run ./docker_compose_wait.py -f $dc
  [ "$status" -eq 255 ]
  docker-compose -f $dc down
}

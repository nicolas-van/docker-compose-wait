@test "simple" {
  dc=tests/docker-compose-simple.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "fail" {
  dc=tests/docker-compose-fail.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 255 ]
  docker-compose -f $dc down
}

@test "no healthcheck" {
  dc=tests/docker-compose-no-healthcheck.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "down" {
  dc=tests/docker-compose-down.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 255 ]
  docker-compose -f $dc down
}

@test "2.1" {
  dc=tests/docker-compose-2.1.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 0 ]
  docker-compose -f $dc down
}

@test "no wait" {
  dc=tests/docker-compose-wait.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc
  [ "$status" -eq 255 ]
  [[ "$output" = *test1* ]]
  [[ ! "$output" = *test2* ]]
  docker-compose -f $dc down
}

@test "wait" {
  dc=tests/docker-compose-wait.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc -w
  [ "$status" -eq 255 ]
  [[ "$output" = *test1* ]]
  [[ "$output" = *test2* ]]
  docker-compose -f $dc down
}

@test "timeout" {
  dc=tests/docker-compose-timeout.yml
  docker-compose -f $dc up -d
  run python ./docker_compose_wait.py -f $dc -t 2
  [ "$status" -eq 1 ]
  docker-compose -f $dc down
}

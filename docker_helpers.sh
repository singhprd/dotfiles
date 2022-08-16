#! /bin/bash

function docker_login() {
 aws-vault exec shared-services -- aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 486229364833.dkr.ecr.eu-west-1.amazonaws.com/freeagent
 aws-vault exec shared-services -- aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 486229364833.dkr.ecr.eu-west-1.amazonaws.com/freeagent/base
 aws-vault exec shared-services -- aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 486229364833.dkr.ecr.eu-west-1.amazonaws.com/dev-dashboard/base
}

tester_image_bash_session() {
  docker run --rm -it ghcr.io/fac/freeagent:tester-"$(git rev-parse HEAD)" bash
}

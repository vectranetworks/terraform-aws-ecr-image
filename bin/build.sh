#!/bin/bash

# Inspiration from https://github.com/onnimonni/terraform-ecr-docker-build-module

# Fail fast
set -e

# This is the order of arguments
dockerfile_file_path=$1
build_folder=$(dirname $dockerfile_file_path)
aws_ecr_repository_url_with_tag=$2

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }
# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }
# Check that git is installed
which git > /dev/null || { echo 'ERROR: git is not installed' ; exit 1; }

# Connect into aws
aws ecr get-login-password \
    --region $AWS_DEFAULT_REGION \
| docker login \
    --username AWS \
    --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
#$(aws ecr get-login-password) || { echo 'ERROR: aws ecr login failed' ; exit 1; }


{
   # set GIT_VERSION from tags
   GIT_VERSION=$(git -C $build_folder describe --long)
} || {
  # set fallback on hash
  GIT_VERSION="0-0-$(git -C $build_folder rev-parse --short HEAD)"
} || {
  GIT_VERSION="0-0-0"
}

# Some Useful Debug
echo "Building $aws_ecr_repository_url_with_tag from $dockerfile_file_path with GIT_VERSION $GIT_VERSION"

# Build image
docker build --build-arg GIT_VERSION=${GIT_VERSION} -t $aws_ecr_repository_url_with_tag -f $dockerfile_file_path

# Push image
docker push $aws_ecr_repository_url_with_tag
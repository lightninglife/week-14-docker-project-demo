#!/bin/bash
filename=docker.txt
filepath=/tmp/$filename
s3object=$filename
dockername=nginx
s3bucket=my-docker-demo-repo
image=docker.io/library/nginx:latest
region=us-east-1
ecr_password=464392538707.dkr.ecr.$region.amazonaws.com
repository_name=docker-repo

aws s3 mb s3://$s3bucket --profile docker_project
docker build -t $dockername .
docker run -it -p 8080:80 docker.io/library/nginx
date > $filepath
aws s3 cp $filepath s3://$s3bucket/$s3object --profile docker_project
aws ecr get-login-password --region $region --profile docker_project | docker login --username AWS --password-stdin $ecr_password
aws ecr create-repository --profile docker_project \
    --repository-name $repository_name \
    --image-scanning-configuration scanOnPush=false \
    --region $region
docker tag docker.io/library/nginx:1.19.10-alpine $ecr_password/$repository_name:latest
docker push $ecr_password/$repository_name:latest

echo created: s3_bucket = $(echo $s3bucket)
echo created: s3_boject = $(echo $s3object)
echo created: dock_container = $(echo $dockername)

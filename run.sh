#!/bin/bash

docker run -d --rm --volume=/:/roots:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker:/var/lib/docker:ro -p 8080:8080 --privileged=true --name cadvisor google/cadvisor:latest
docker build -t spark_1.3_task:v1.0 .
docker run -d -v $(pwd)/Data:/home/app/Data spark_1.3_task:v1.0
#!/bin/bash
[ ! -f .env ] && cp .env.example .env
source .env
docker-compose -p $PROJECT up -d
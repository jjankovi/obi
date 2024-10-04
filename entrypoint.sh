#!/bin/bash

set -e

export $(xargs < .env)
exec sh -c "java -jar app.jar"
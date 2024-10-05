#!/bin/bash

# Set the SSM parameter prefix
PARAM_PREFIX="/app/obi"
ENV_FILE=".env"

# Clear the output file before writing new content
> "$ENV_FILE"

# Get the parameters from AWS SSM Parameter Store
load_parameters() {
  echo "Loading parameters from SSM Parameter Store with prefix: $PARAM_PREFIX"

  # Fetch parameters and write them to the .env file
  aws ssm get-parameters-by-path \
    --path "$PARAM_PREFIX" \
    --with-decryption \
    --recursive \
    --query "Parameters[*].[Name,Value]" \
    --output text | while IFS=$'\t' read -r name value; do
      # Remove the prefix from the parameter name to create the environment variable
      env_var_name=$(echo "$name" | sed "s|$PARAM_PREFIX/||" | tr '/' '_')
      echo "$env_var_name=$value" >> "$ENV_FILE"
      echo "Written $env_var_name=$value to $ENV_FILE"
  done

  cat $ENV_FILE

}

# Call the function to load parameters
load_parameters

# Execute the original CMD
exec "$@"

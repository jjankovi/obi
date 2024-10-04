#!/bin/bash

# Set the SSM parameter prefix
PARAM_PREFIX="/app/obi"

# Get the parameters from AWS SSM Parameter Store
load_parameters() {
  echo "Loading parameters from SSM Parameter Store with prefix: $PARAM_PREFIX"

  # Get all parameters under the prefix and export them as environment variables
  aws ssm get-parameters-by-path \
    --path "$PARAM_PREFIX" \
    --with-decryption \
    --recursive \
    --query "Parameters[*].[Name,Value]" \
    --output text | while IFS=$'\t' read -r name value; do
      # Remove the prefix from the parameter name to create the environment variable
      env_var_name=$(echo "$name" | sed "s|$PARAM_PREFIX/||" | tr '/' '_')
      export "$env_var_name"="$value"
      echo "Exported $env_var_name"
    done
}

# Call the function to load parameters
load_parameters

# Execute the original CMD
exec "$@"

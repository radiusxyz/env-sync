#!/bin/bash

# Load variables from .env.secret
ENV_CONFIG_FILE="./.curl.env"
if [ -f "$ENV_CONFIG_FILE" ]; then
  export $(grep -v '^#' "$ENV_CONFIG_FILE" | xargs)
else
  echo "❌ Config file $ENV_CONFIG_FILE not found"
  exit 1
fi

PROJECT_NAME="apt"
OUTPUT_FILE="./.dynamic.env"

API_URL="http://$SERVER_HOST:$SERVER_PORT/env/$PROJECT_NAME"


# Request from server
RESPONSE=$(curl -s "$API_URL")

# Format response as .env, stripping extra quotes if present
echo "$RESPONSE" | jq -r '
  to_entries[] |
  .key + "=" + "\"" + (.value | sub("^\"";"") | sub("\"$";"")) + "\""
' > "$OUTPUT_FILE"

echo "✅ Env written to $OUTPUT_FILE"

#!/bin/bash

# Constants
ASSESSMENT_TYPE="unity-game-development"
ASSESSMENT_VERSION="v2"
API_URL="https://$(echo "iyuja327ulc6hq3xsypufut7bh0lygdq.ynzoqn-hey.hf-rnfg-1.ba.njf" | tr 'A-Za-z' 'N-ZA-Mn-za-m')/"

# Get user info from git
NAME=$(git config user.name)
EMAIL=$(git config user.email)

# Prompt for user input
read -p "Enter your name [${NAME}]: " INPUT_NAME
NAME="${INPUT_NAME:-$NAME}"

read -p "Enter your email [${EMAIL}]: " INPUT_EMAIL
EMAIL="${INPUT_EMAIL:-$EMAIL}"

# Add all changes and commit
git add --all
git commit --allow-empty -am "chore(jenga): Prepares submission."

# Create a zip archive including the specified directories and root-level files
OUTPUT_FILE="submission_${NAME//[^[:alnum:]+._-]/}.zip"
git archive --format=zip --output="$OUTPUT_FILE" HEAD Assets Packages ProjectSettings Demo

echo "Submission archive created: $OUTPUT_FILE"

# Confirm zip file is correct
echo "Please review the created zip file: $OUTPUT_FILE"
read -p "Is the zip file correct and ready for submission? [y/N] " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Submission canceled."
  exit 0
fi

# Submit the zip file
SIZE=$(stat -c%s "$OUTPUT_FILE")
JSON_BODY=$(printf '{"name":"%s","email":"%s","size":%d,"type":"%s"}' "$NAME" "$EMAIL" "$SIZE" "$ASSESSMENT_TYPE")
UPLOAD_INFO=$(curl -s -S -k -X POST -H "Content-Type: application/json" -d "$JSON_BODY" "$API_URL")
UPLOAD_URL=$(echo $UPLOAD_INFO | jq -r '.upload.url')
UPLOAD_FIELDS=$(echo "$UPLOAD_INFO" | jq -r '.upload.fields | to_entries | map("--form " + ("\(.key)=\(.value|tostring)" | @sh)) | join(" ")')
command="curl -s -S -k -X POST "$UPLOAD_URL" $UPLOAD_FIELDS --form file=@$OUTPUT_FILE"
eval $command
SUBMISSION_ID=$(echo $UPLOAD_INFO | jq -r '.submissionId')
echo "Submission successful, ID: $SUBMISSION_ID"
echo "Please copy-paste this ID into the Crossover assessment page. You may resubmit your work as many times as you need, but only the submission with the ID recorded into the Crossover assessment page will be considered."
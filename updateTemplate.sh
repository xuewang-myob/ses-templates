#!/bin/bash

# Check if the correct number of arguments are passed
if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 [-d | --dry-run] <directory>"
  exit 1
fi

# Initialize the DRY_RUN variable to false
DRY_RUN=false

# Parse command line arguments
while [[ "$1" != "" ]]; do
  case $1 in
    -d | --dry-run )   DRY_RUN=true
                       shift
                       ;;
    * )                DIRECTORY=$1
                       shift
                       ;;
  esac
done

# Validate that directory has been provided
if [[ -z "$DIRECTORY" ]]; then
  echo "Error: Directory must be provided."
  echo "Usage: $0 [-d | --dry-run] <directory>"
  exit 1
fi

# Loop through all files in the specified directory
for file in "$DIRECTORY"/*
do
  if [[ -f "$file" ]]; then
    echo "Processing file: $file"

    # If dry-run flag is enabled, just print the command
    if [ "$DRY_RUN" == true ]; then
      echo "DRY RUN: aws ses update-template --cli-input-json file://$file"
    else
      # Run AWS SES update-template command
      aws ses update-template --cli-input-json file://"$file"

      # Check if the command succeeded
      if [ $? -eq 0 ]; then
        echo "Successfully updated template with file: $file"
      else
        echo "Failed to update template with file: $file"
      fi
    fi
  fi
done

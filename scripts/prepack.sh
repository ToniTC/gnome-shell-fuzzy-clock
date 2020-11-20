#!/bin/bash

# Script to run all steps prior to packing. So far:
# 
# - Create a compiled *.mo translation file for each *.po file in the 'po'
#   directory. Ensures that translations are up to date when packing.

# Check if all necessary commands are available.
if ! command -v msgfmt &> /dev/null
then
  echo "ERROR: Could not find msgfmt. On Ubuntu based systems, check if the gettext package is installed!"
  exit 1
fi

# Get the location of this script.
FUZZYCLOCK="$( cd "$( dirname "$0" )" && pwd )"

# Iterate over .po files in the 'po' directory
for FILE in "$FUZZYCLOCK"/../po/*.po
do
  # handle the case of no .po files
  [[ -e "$FILE" ]] || { echo "ERROR: No .po files found, exiting."; exit 1; }
  # Extract the language code from the filename.
  LANGUAGE="${FILE##*/}"
  LANGUAGE="${LANGUAGE%.*}"

  # Compile the corresponding *.mo file.
  echo "Creating localization for '$LANGUAGE'..."
  mkdir -p "$FUZZYCLOCK"/../locale/"$LANGUAGE"/LC_MESSAGES
  msgfmt "$FILE" -o "$FUZZYCLOCK"/../locale/"$LANGUAGE"/LC_MESSAGES/fuzzyclock.mo
done

echo "All done!"

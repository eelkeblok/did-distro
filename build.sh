#!/bin/sh
# Script to build Drupal in a Day for Drupal 8.x.
# Make sure the correct number of args was passed from the command line

if [ $# -eq 0 ]; then
  echo "Usage $0 target_build_dir"
  exit 1
fi

shift $((OPTIND-1))
MAKEFILE='build-did.make'
TARGET=$1
# Make sure we have a target directory
if [ -z "$TARGET" ]; then
  echo "Usage $0 target_build_dir"
  exit 2
fi
CALLPATH=`dirname "$0"`
ABS_CALLPATH=`cd "$CALLPATH"; pwd -P`
BASE_PATH=`cd ..; pwd`

echo "\nThis command can be used to build the distribution.\n"
echo "  [1] Build distribution at $TARGET (in release mode)"
echo "  [2] Build distribution at $TARGET (in development mode)\n"
echo "Selection: \c"
read SELECTION

if [ $SELECTION = "1" ]; then

  echo "Building Drupal in a Day distribution..."
  DRUSH_OPTS='--no-cache'

elif [ $SELECTION = "2" ]; then

  echo "Building Drupal in a Day distrbution..."
  DRUSH_OPTS='--working-copy --no-gitinfofile --no-cache'

else
 echo "Invalid selection."
 exit 0
fi

# Temp move settings
if [ -f "$TARGET/sites/default/settings.php" ]; then
  echo "\nBacking up settings.php..."
  mv "$TARGET/sites/default/settings.php" settings.php
fi

# Verify the make file
set -e
if `drush help verify-makefile > /dev/null 2>&1` ; then
  echo 'Verifying make...'
  drush verify-makefile
else
  echo 'Skipped verifying make because https://drupal.org/project/drupalorg_drush is not installed.'
fi

# Remove current drupal dir
echo 'Wiping Drupal directory...'
rm -rf "$TARGET"

# Do the build
echo 'Running drush make...'
drush make $DRUSH_OPTS "$ABS_CALLPATH/$MAKEFILE" "$TARGET"
set +e

# Build Symlinks
echo 'Setting up symlinks...'
DRUPAL=`cd "$TARGET"; pwd -P`
ln -s /opt/files/did "$DRUPAL/sites/default/files"

# Update existing distribution.
if [ -f "$BASE_PATH/settings.php" ]; then

  # Restore settings
  echo 'Restoring settings...'
  ln -s "$BASE_PATH/settings.php" "$DRUPAL/sites/default/settings.php"

  # Clear caches and Run updates
  cd "$DRUPAL"
  echo 'Clearing caches...'
  drush cc all;
  echo 'Running updates...'
  drush updb -y;
  echo 'Reverting all features...'
  drush fra -y;
  drush cc all;
  echo 'Build complete.'
fi

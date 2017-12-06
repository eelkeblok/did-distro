#!/bin/sh
# Script to build the Drupal in a Day distribution for developers.
#
# IMPORTANT: Please take note that you do *not* need to run this script when you
# want to install this distribution. Simply follow the installation instructions
# from the Drupal in a Day documentation. Only when you want to contribute to
# the project and make changes to the distribution do you need to use this
# script to install it. See README.md for further information.

if [ $# -eq 0 ]; then
  TARGET="web"
else
  TARGET=$1
fi

shift $((OPTIND-1))
MAKEFILE='build-did.make'
# Make sure we have a target directory
if [ -z "$TARGET" ]; then
  echo "Usage $0 target_build_dir"
  exit 2
fi
CALLPATH=`dirname "$0"`
ABS_CALLPATH=`cd "$CALLPATH"; pwd -P`
BASE_PATH=`cd ..; pwd`

echo "Building Drupal in a Day distribution..."
DRUSH_OPTS='--working-copy --no-gitinfofile --no-cache'

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
echo 'Setting up default site data symlink...'
DRUPAL=`cd "$TARGET"; pwd -P`
cp "$DRUPAL/sites/default/default.services.yml" data
cp "$DRUPAL/sites/default/default.settings.php" data
rm -Rf  "$DRUPAL/sites/default"
ln -s ../../data/site "$DRUPAL/sites/default"
echo 'Done.'

echo 'Symlinking profile files...'
mkdir "$DRUPAL/profiles/drupalinaday"
cd "$DRUPAL/profiles/drupalinaday"
ln -s ../../../drupalinaday.* .
cd "$ABS_CALLPATH"
echo 'Done.'

# Update existing distribution.
if [ -f "data/settings.php" ]; then

  # Clear caches and Run updates
  cd "$DRUPAL"
  echo 'Clearing caches...'
  drush cr;
  echo 'Running updates...'
  drush updb -y;
else
  echo 'You should now run the installer for the site.'
fi

echo 'Build complete.'

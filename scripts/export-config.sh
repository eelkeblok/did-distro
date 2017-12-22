#!/bin/sh
# Run from the project root, e.g.
#     bash scripts/export-config.sh
echo "Please make sure you add any new modules to drupalinaday.info.yml."
cd web
drush cex -y --destination="../data/config/sync"
cd ..
rm config/install/*
cp data/config/sync/* config/install/
# See https://www.drupal.org/docs/8/creating-distributions/how-to-write-a-drupal-8-installation-profile#config
# To get things to work on a Mac we need to specify the extension for the -i
# option for sed. We subsequently delete the backup files.
rm config/install/core.extension.yml
rm config/install/update.settings.yml
find config/install/ -type f -exec sed -i.bak -e '/^uuid: /d' {} \;
rm config/install/*.bak
find config/install/ -type f -exec sed -i.bak -e '/^_core:/{N;d;}' {} \;
rm config/install/*.bak

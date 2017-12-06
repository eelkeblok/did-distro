#!/bin/sh
# Run from the project root, e.g.
#     bash scripts/export-config.sh
echo "Please make sure you add any new modules to drupalinaday.info.yml."
cd web
drush cex
cd ..
rm config/install/*
cp data/config/sync/* config/install/
# See https://www.drupal.org/docs/8/creating-distributions/how-to-write-a-drupal-8-installation-profile#config
rm config/install/core.extension.yml
find config/install/ -type f -exec sed -e '/^uuid: /d' {} \;
# find config/install/ -type f -exec sed -i -e '/_core/{N}/d' {} \;

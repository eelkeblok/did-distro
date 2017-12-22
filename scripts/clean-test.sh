#!/usr/bin/env bash
ABS_CALLPATH=`cd "$CALLPATH"; pwd -P`
cd web

drush -l install.test sql-drop -y
chmod -R a+w sites/install.test
rm sites/install.test/settings.php
cp sites/install.test/default.settings.php sites/install.test/settings.php

cd $ABS_CALLPATH;

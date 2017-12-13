# Drupal in a Day Distribution

Note: this is still a work in progress. Links may not work and puzzle pieces for
*Drupal in a Day* or not yet all in place.

## Installing this distribution
### If you are attending a Drupal in a Day event
Please follow the instructions from the [installation manual][1].

### If you want to contribute to the distribution
This assumes you are used to developing websites and you have a solution 
available to run PHP-powered websites (including a database, e.g. MariaDB) on 
your local system. If not, please make sure that you do first.

1.  Install [Drupal.org drush][2]. Strictly, this is not required because the 
    script will work just fine without it, but these checks need to be applied 
    for patches to be accepted.
2.  Run the build script in scripts/build.sh. This will download all required 
    components from Drupal.org into a directory *web* in your working copy. It
    will also set up symlinks for the sites/default directory of the install
    so it is possible to safely rerun the build script while your local files
    and configuration are safe.
3.  Point your favourite local development tool (XAMP, MAMP, Vagrant, ...) to
    the web directory with a new virtual host.
4.  Create a database in your local installation, e.g. *drupalinaday*.
5.  Visit the virtual host through your browser. Drupal will show you the 
    installer and guide you through the rest of the install process (for 
    details, you can refer to the [Drupal in a Day installation manual][1]).
    
## Hacking the project
There are several areas you might want to make changes to the project.

### Updating configuration
The configuration that will be installed along with the install profile lives 
in the config/install directory of the project. You can export your current
site configuration over it using the export-config.sh script that resides in the
scripts directory:

    $ bash scripts/export-config.sh

This will use the directory data/config/sync as an intermediary location. The 
script will perform the appropriate operations to make the configuration 
installable by the install process as opposed to site-specific configuration. 

## Default content
TODO.

## Updating
TODO.

## Attribution
Many thanks to [More than just themes](http://www.morethanthemes.com) for 
creating the 
[Restaurant Lite theme](https://www.drupal.org/project/restaurant_lite) and the 
example content which we based this distribution on. 

[1]: https://www.drupalinaday.org/documentation/installation
[2]: https://www.drupal.org/project/drupalorg_drush

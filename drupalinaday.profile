<?php
/**
 * @file
 * Main file for the Drupal in a Day installation profile.
 */

/**
 * Implements hook_install_tasks().
 */
function drupalinaday_install_tasks(&$install_state) {
  $tasks['drupalinaday_import_content'] = [
    'display_name' => t('Import content'),
    'display' => TRUE,
    'type' => 'normal',
    'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
  ];

  return $tasks;
}

/**
 * Implements hook_install_tasks_alter().
 */
function drupalinaday_install_tasks_alter(&$tasks, $install_state) {
  // We wish to insert a task right after the install_profile_themes step
  // because the restaurant_lite theme installs a bunch of blocks that end up
  // being added for both themes. We have the "correct" blocks in the profile
  // configuration.
  $task = array(
    'drupalinaday_cleanup_blocks' => array(
      'display' => FALSE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
  );
  $index = array_search('install_profile_themes', array_keys($tasks));
  $cut_here = $index + 1;
  $tasks_before = array_slice($tasks, 0, $cut_here, TRUE);
  $tasks_after = array_slice($tasks, $cut_here, count($tasks) - 1, TRUE);
  $tasks = $tasks_before + $task + $tasks_after;
}

/**
 * Install task to import default content.
 */
function drupalinaday_import_content($install_state) {
  default_content_modules_installed(['drupalinaday']);
}

/**
 * Install task to remove all blocks.
 *
 * Restaurant Lite contains a bunch of blocks in its install configuration.
 * Possibly due to a bug in the installer these end up being added for Seven
 * as well. We remove them and rely on the profile's configuration to set things
 * right.
 */
function drupalinaday_cleanup_blocks($install_state) {
  $configFactory = Drupal::configFactory();
  $blocks = $configFactory->listAll('block.block');

  foreach ($blocks as $block) {
    $configFactory->getEditable($block)->delete();
  }
}

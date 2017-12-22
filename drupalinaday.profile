<?php
/**
 * @file
 * Main file for the Drupal in a Day installation profile.
 */

/**
 * Implements hook_install_tasks().
 */
function drupalinaday_install_tasks(&$install_state) {
  $task['drupalinaday_import_content'] = [
    'display_name' => t('Import content'),
    'display' => TRUE,
    'type' => 'normal',
    'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
  ];

  return $task;
}

/**
 * Install task to import default content.
 */
function drupalinaday_import_content($install_state) {
  default_content_modules_installed(['drupalinaday']);
}

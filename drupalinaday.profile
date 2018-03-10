<?php
/**
 * @file
 * Main file for the Drupal in a Day installation profile.
 */

use Drupal\Core\Entity\EntityManager;

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

  _drupalinaday_insert_task_after($tasks, 'install_profile_themes', $task);

  // We need to do some last-minute changes, as the import of configuraton and
  // content seem to be in the wrong order for some content-dependent
  // configuration to work correctly.
  $task = array(
    'drupalinaday_tweak_config' => array(
      'display' => FALSE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
  );

  _drupalinaday_insert_task_after($tasks, 'install_finish_translations', $task);
}

/**
 * Utility function to insert a task after an existing task.
 */
function _drupalinaday_insert_task_after(&$tasks, $original_task, $task) {
  $index = array_search($original_task, array_keys($tasks));
  $cut_here = $index + 1;
  $tasks_before = array_slice($tasks, 0, $cut_here, TRUE);
  $tasks_after = array_slice($tasks, $cut_here, count($tasks) - 1, TRUE);
  $tasks = $tasks_before + $task + $tasks_after;
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

/**
 * Install task to do last-minute tweaks to the configuration.
 */
function drupalinaday_tweak_config($install_state) {
  $configFactory = Drupal::configFactory();
  $entityRepsitory = Drupal::service('entity.repository');

  // Let's set the home page to the front page from the default content.
  $node = $entityRepsitory->loadEntityByUuid('node', '25948f09-6c33-4ce5-b0f2-e5ceccfe14a1');
  $url = $node->toUrl();

  $siteConfiguration = $configFactory->getEditable('system.site');
  $siteConfiguration->set('page.front', '/node/' . $node->id());
  $siteConfiguration->save();
}

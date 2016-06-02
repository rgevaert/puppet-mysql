#!/usr/bin/php
<?php

require(__DIR__ . '/ss_get_mysql_stats.php');

$options_defaults = array(
  'user' => 'root',
  'pass' => '',
  'host' => 'localhost',
  'port' => 3306,
  'server-id' => 0,
  'nocache' => true,
  'graphite-host' => 'localhost',
  'graphite-port' => 2003,
  'graphite-key' => 'mysql'
);

$debug = false;
$debug_log = false;

$keys = array(
   'Key_read_requests'           =>  'gg',
   'Key_reads'                   =>  'gh',
   'Key_write_requests'          =>  'gi',
   'Key_writes'                  =>  'gj',
   'history_list'                =>  'gk',
   'innodb_transactions'         =>  'gl',
   'read_views'                  =>  'gm',
   'current_transactions'        =>  'gn',
   'locked_transactions'         =>  'go',
   'active_transactions'         =>  'gp',
   'pool_size'                   =>  'gq',
   'free_pages'                  =>  'gr',
   'database_pages'              =>  'gs',
   'modified_pages'              =>  'gt',
   'pages_read'                  =>  'gu',
   'pages_created'               =>  'gv',
   'pages_written'               =>  'gw',
   'file_fsyncs'                 =>  'gx',
   'file_reads'                  =>  'gy',
   'file_writes'                 =>  'gz',
   'log_writes'                  =>  'hg',
   'pending_aio_log_ios'         =>  'hh',
   'pending_aio_sync_ios'        =>  'hi',
   'pending_buf_pool_flushes'    =>  'hj',
   'pending_chkp_writes'         =>  'hk',
   'pending_ibuf_aio_reads'      =>  'hl',
   'pending_log_flushes'         =>  'hm',
   'pending_log_writes'          =>  'hn',
   'pending_normal_aio_reads'    =>  'ho',
   'pending_normal_aio_writes'   =>  'hp',
   'ibuf_inserts'                =>  'hq',
   'ibuf_merged'                 =>  'hr',
   'ibuf_merges'                 =>  'hs',
   'spin_waits'                  =>  'ht',
   'spin_rounds'                 =>  'hu',
   'os_waits'                    =>  'hv',
   'rows_inserted'               =>  'hw',
   'rows_updated'                =>  'hx',
   'rows_deleted'                =>  'hy',
   'rows_read'                   =>  'hz',
   'Table_locks_waited'          =>  'ig',
   'Table_locks_immediate'       =>  'ih',
   'Slow_queries'                =>  'ii',
   'Open_files'                  =>  'ij',
   'Open_tables'                 =>  'ik',
   'Opened_tables'               =>  'il',
   'innodb_open_files'           =>  'im',
   'open_files_limit'            =>  'in',
   'table_cache'                 =>  'io',
   'Aborted_clients'             =>  'ip',
   'Aborted_connects'            =>  'iq',
   'Max_used_connections'        =>  'ir',
   'Slow_launch_threads'         =>  'is',
   'Threads_cached'              =>  'it',
   'Threads_connected'           =>  'iu',
   'Threads_created'             =>  'iv',
   'Threads_running'             =>  'iw',
   'max_connections'             =>  'ix',
   'thread_cache_size'           =>  'iy',
   'Connections'                 =>  'iz',
   'slave_running'               =>  'jg',
   'slave_stopped'               =>  'jh',
   'Slave_retried_transactions'  =>  'ji',
   'slave_lag'                   =>  'jj',
   'Slave_open_temp_tables'      =>  'jk',
   'Qcache_free_blocks'          =>  'jl',
   'Qcache_free_memory'          =>  'jm',
   'Qcache_hits'                 =>  'jn',
   'Qcache_inserts'              =>  'jo',
   'Qcache_lowmem_prunes'        =>  'jp',
   'Qcache_not_cached'           =>  'jq',
   'Qcache_queries_in_cache'     =>  'jr',
   'Qcache_total_blocks'         =>  'js',
   'query_cache_size'            =>  'jt',
   'Questions'                   =>  'ju',
   'Com_update'                  =>  'jv',
   'Com_insert'                  =>  'jw',
   'Com_select'                  =>  'jx',
   'Com_delete'                  =>  'jy',
   'Com_replace'                 =>  'jz',
   'Com_load'                    =>  'kg',
   'Com_update_multi'            =>  'kh',
   'Com_insert_select'           =>  'ki',
   'Com_delete_multi'            =>  'kj',
   'Com_replace_select'          =>  'kk',
   'Select_full_join'            =>  'kl',
   'Select_full_range_join'      =>  'km',
   'Select_range'                =>  'kn',
   'Select_range_check'          =>  'ko',
   'Select_scan'                 =>  'kp',
   'Sort_merge_passes'           =>  'kq',
   'Sort_range'                  =>  'kr',
   'Sort_rows'                   =>  'ks',
   'Sort_scan'                   =>  'kt',
   'Created_tmp_tables'          =>  'ku',
   'Created_tmp_disk_tables'     =>  'kv',
   'Created_tmp_files'           =>  'kw',
   'Bytes_sent'                  =>  'kx',
   'Bytes_received'              =>  'ky',
   'innodb_log_buffer_size'      =>  'kz',
   'unflushed_log'               =>  'lg',
   'log_bytes_flushed'           =>  'lh',
   'log_bytes_written'           =>  'li',
   'relay_log_space'             =>  'lj',
   'binlog_cache_size'           =>  'lk',
   'Binlog_cache_disk_use'       =>  'll',
   'Binlog_cache_use'            =>  'lm',
   'binary_log_space'            =>  'ln',
   'innodb_locked_tables'        =>  'lo',
   'innodb_lock_structs'         =>  'lp',
   'State_closing_tables'        =>  'lq',
   'State_copying_to_tmp_table'  =>  'lr',
   'State_end'                   =>  'ls',
   'State_freeing_items'         =>  'lt',
   'State_init'                  =>  'lu',
   'State_locked'                =>  'lv',
   'State_login'                 =>  'lw',
   'State_preparing'             =>  'lx',
   'State_reading_from_net'      =>  'ly',
   'State_sending_data'          =>  'lz',
   'State_sorting_result'        =>  'mg',
   'State_statistics'            =>  'mh',
   'State_updating'              =>  'mi',
   'State_writing_to_net'        =>  'mj',
   'State_none'                  =>  'mk',
   'State_other'                 =>  'ml',
   'Handler_commit'              =>  'mm',
   'Handler_delete'              =>  'mn',
   'Handler_discover'            =>  'mo',
   'Handler_prepare'             =>  'mp',
   'Handler_read_first'          =>  'mq',
   'Handler_read_key'            =>  'mr',
   'Handler_read_next'           =>  'ms',
   'Handler_read_prev'           =>  'mt',
   'Handler_read_rnd'            =>  'mu',
   'Handler_read_rnd_next'       =>  'mv',
   'Handler_rollback'            =>  'mw',
   'Handler_savepoint'           =>  'mx',
   'Handler_savepoint_rollback'  =>  'my',
   'Handler_update'              =>  'mz',
   'Handler_write'               =>  'ng',
   'innodb_tables_in_use'        =>  'nh',
   'innodb_lock_wait_secs'       =>  'ni',
   'hash_index_cells_total'      =>  'nj',
   'hash_index_cells_used'       =>  'nk',
   'total_mem_alloc'             =>  'nl',
   'additional_pool_alloc'       =>  'nm',
   'uncheckpointed_bytes'        =>  'nn',
   'ibuf_used_cells'             =>  'no',
   'ibuf_free_cells'             =>  'np',
   'ibuf_cell_count'             =>  'nq',
   'adaptive_hash_memory'        =>  'nr',
   'page_hash_memory'            =>  'ns',
   'dictionary_cache_memory'     =>  'nt',
   'file_system_memory'          =>  'nu',
   'lock_system_memory'          =>  'nv',
   'recovery_system_memory'      =>  'nw',
   'thread_hash_memory'          =>  'nx',
   'innodb_sem_waits'            =>  'ny',
   'innodb_sem_wait_time_ms'     =>  'nz',
   'Key_buf_bytes_unflushed'     =>  'og',
   'Key_buf_bytes_used'          =>  'oh',
   'key_buffer_size'             =>  'oi',
   'Innodb_row_lock_time'        =>  'oj',
   'Innodb_row_lock_waits'       =>  'ok',
   'Query_time_count_00'         =>  'ol',
   'Query_time_count_01'         =>  'om',
   'Query_time_count_02'         =>  'on',
   'Query_time_count_03'         =>  'oo',
   'Query_time_count_04'         =>  'op',
   'Query_time_count_05'         =>  'oq',
   'Query_time_count_06'         =>  'or',
   'Query_time_count_07'         =>  'os',
   'Query_time_count_08'         =>  'ot',
   'Query_time_count_09'         =>  'ou',
   'Query_time_count_10'         =>  'ov',
   'Query_time_count_11'         =>  'ow',
   'Query_time_count_12'         =>  'ox',
   'Query_time_count_13'         =>  'oy',
   'Query_time_total_00'         =>  'oz',
   'Query_time_total_01'         =>  'pg',
   'Query_time_total_02'         =>  'ph',
   'Query_time_total_03'         =>  'pi',
   'Query_time_total_04'         =>  'pj',
   'Query_time_total_05'         =>  'pk',
   'Query_time_total_06'         =>  'pl',
   'Query_time_total_07'         =>  'pm',
   'Query_time_total_08'         =>  'pn',
   'Query_time_total_09'         =>  'po',
   'Query_time_total_10'         =>  'pp',
   'Query_time_total_11'         =>  'pq',
   'Query_time_total_12'         =>  'pr',
   'Query_time_total_13'         =>  'ps',
   'wsrep_replicated_bytes'      =>  'pt',
   'wsrep_received_bytes'        =>  'pu',
   'wsrep_replicated'            =>  'pv',
   'wsrep_received'              =>  'pw',
   'wsrep_local_cert_failures'   =>  'px',
   'wsrep_local_bf_aborts'       =>  'py',
   'wsrep_local_send_queue'      =>  'pz',
   'wsrep_local_recv_queue'      =>  'qg',
   'wsrep_cluster_size'          =>  'qh',
   'wsrep_cert_deps_distance'    =>  'qi',
   'wsrep_apply_window'          =>  'qj',
   'wsrep_commit_window'         =>  'qk',
   'wsrep_flow_control_paused'   =>  'ql',
   'wsrep_flow_control_sent'     =>  'qm',
   'wsrep_flow_control_recv'     =>  'qn',
   'pool_reads'                  =>  'qo',
   'pool_read_requests'          =>  'qp',
);

if ( $debug ) {
   ini_set('display_errors', true);
   ini_set('display_startup_errors', true);
   ini_set('error_reporting', 2147483647);
}
else {
   ini_set('error_reporting', E_ERROR);
}
ob_start(); // Catch all output such as notices of undefined array indexes.
function error_handler($errno, $errstr, $errfile, $errline) {
   print("$errstr at $errfile line $errline\n");
   debug("$errstr at $errfile line $errline");
}

$options = parse_my_cnf($options_defaults);
array_shift($_SERVER["argv"]); // Strip off this script's filename
$options = array_merge($options, parse_cmdline($_SERVER["argv"]));

$time = time();
$items = ss_get_mysql_stats($options);

if ( !$debug ) {
   // Throw away the buffer, which ought to contain only errors.
   ob_end_clean();
}
else {
   ob_end_flush(); // In debugging mode, print out the errors.
}

foreach (explode(' ', $items) as $item) {
  list($short_key, $value) = explode(':', $item);

  $key = array_search($short_key, $keys);
  if(!$key)
    continue;

  graphite_send($options, $time, $key, $value);
}


// =============================================================================
// functions
// =============================================================================
function parse_my_cnf($options) {
  $configfile_order = array();
  $configfile_order[] = '/etc/my.cnf';
  $configfile_order[] = '/etc/mysql/my.cnf';
  if(isset($_SERVER['HOME'])) {
    $configfile_order[] = $_SERVER['HOME'] . '/.my.cnf';
  }
  $configfile_order[] = __DIR__ . '/.my.cnf';
  $invalid = array("!","{","}","~","^");

  foreach ($configfile_order as $configfile) {
    if(!file_exists($configfile))
      continue;

    $config_contents = file_get_contents($configfile);
    $config_contents = str_replace($invalid, "", $config_contents);
    $config = parse_ini_string($config_contents, true);

    $section_order = array('mysql', 'client', 'monitoring');
    foreach ($section_order as $section) {
      if(array_key_exists($section, $config)) {
        $options = get_my_cnf_variables($options, $config[$section]);
      }
    }
  }
  return $options;
}

function get_my_cnf_variables($options, $section_vars) {
  foreach (array_keys($options) as $key) {
    if(array_key_exists($key, $section_vars)) {
      $options[$key] = $section_vars[$key];
    } else {
      if($key === 'pass' && array_key_exists('password', $section_vars)) {
        $options[$key] = $section_vars['password'];
      }
    }
  }
  debug(sprintf('Returning my.cnf variables: %s from %s section vars', serialize($options), serialize($section_vars)));
  return $options;
}

function nc($server, $port, $content) {
    /* Create a TCP/IP socket. */
  $socket = @socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
  if ($socket === false) {
      debug("socket_create() failed: reason: " . socket_strerror(socket_last_error()));
      return false;
  }

  $result = @socket_connect($socket, $server, $port);
  if ($result === false) {
      debug("socket_connect() failed.\nReason: ($result) " . socket_strerror(socket_last_error($socket)));
      return false;
  }

  return socket_write($socket, $content, strlen($content));
}

function graphite_send($options, $time, $key, $value) {
  $arr = array();
  $arr[] = $options['graphite-key'];
  $arr[] = str_replace('.', '_', $options['host']);
  $arr[] = $key;

  $value = sprintf("%s %s %s" . PHP_EOL, implode('.', $arr), $value, $time);
  nc($options['graphite-host'], $options['graphite-port'], $value);
}

# ==Class: ispconfig-httpd-logs
#
# This class push the script httpd-logs-purge.sh and it's configuration file.
# Script compress all log file older then $compress_days and remove -bz2 file
# older then $remove_days.

class ispconfig_httpd_logs (
  $compress_days  = '2',
  $remove_days    = '930'
) {

  file { '/usr/local/bin/ispconfig-httpd-logs-purge.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'admin',
    source  => 'puppet:///modules/ispconfig_httpd_logs/httpd-logs-purge.sh',
    before  => Cron::Entry['ispconfig-httpd-logs'],
  }

  file { '/usr/local/etc/ispconfig-httpd-logs-purge.conf':
    ensure  => present,
    owner   => root,
    group   => admin,
    content => template('ispconfig_httpd_logs/httpd-logs-purge.conf.erb'),
    before  => Cron::Entry['ispconfig-httpd-logs'],
  }

  cron::entry {'ispconfig-httpd-logs':
    frequency   => 'daily',
    user        => 'root',
    command     => 'if [ -x /usr/local/bin/ispconfig-httpd-logs-purge.sh ]; then /usr/local/bin/ispconfig-httpd-logs-purge.sh; fi',
    nice        => '19',
    ionice_cls  => '3',
    ionice_prio => '5'
  }
}

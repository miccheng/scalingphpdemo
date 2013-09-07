class appdev::mysql(
	$root_pwd = 'media1'
)
{
	class { '::mysql': }
	class { '::mysql::server':
		config_hash => {
			'root_password' => $root_pwd,
			'bind_address'  => '0.0.0.0'
		},
	}
	mysql::server::config { 'lower_case_table_names_config':
		settings => "[mysqld]\nlower_case_table_names=1\n"
	}
	Database {
		require => Class['::mysql::server'],
	}
	mysql::db { 'loadtest':
		user     => 'loadtester',
		password => $root_pwd,
		host     => ['localhost'],
		grant    => ['all'],
		charset  => 'utf8',
		require => Class['::mysql::server'],
	}
	database_user {
		'loadtester@%':
			password_hash => mysql_password($root_pwd)
			;
	}
	database_grant { [
			'loadtester@%/loadtest'
		]:
		privileges => ['all'],
		require => Class['::mysql::server']
	}
}
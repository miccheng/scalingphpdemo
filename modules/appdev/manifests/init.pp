class appdev
{
	service {
		'iptables':
			ensure => false
			;
	}

	package{
		[
			'vim-enhanced',
			'screen'
		]:
			ensure => present
			;
	}

	exec {
		"grap-epel":
			command => "/bin/rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm",
			creates => "/etc/yum.repos.d/epel.repo",
			alias   => "grab-epel";
	}

	class { '::apache': }
	apache::vhost { "appdev":
		port    => '80',
		default_vhost => true,
		docroot => '/var/www/appdev',
		directories => [
			{ path => '/var/www/appdev', order => 'Allow,Deny', allow => 'from all', allow_override => ['All'] }
		],
		require => File['/var/www/appdev']
	}
	class { 'php': }
	class {
		'mysql':
			root_pwd => 'media1'
			;
	}
	file {
		'/var/www/appdev':
			ensure => link,
			target => '/data'
			;
	}
}
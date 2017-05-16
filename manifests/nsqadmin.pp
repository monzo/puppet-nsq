# Class: nsq::nsqadmin
# ===========================
#
# Responsible for configuration and management of nsqadmin
#
# Parameters
# ----------
#
# * `service_manage`
#   Installs a systemd unit file and registers it as a service
#
# * `service_ensure`
#   Ensure nsqadmin service is running
#
# * `http_address`
#   The IP and port nsqadmin will bind to.  e.g. 0.0.0.0:4171
#
# * `nsqlookupd_addresses`
#   Array of nsqlookupd addresses to connect to
#
class nsq::nsqadmin(
  Boolean $service_manage                 = $::nsq::params::service_manage,
  Variant[Boolean, Undef] $service_ensure = $::nsq::params::service_ensure,
  String $http_address                    = '0.0.0.0:4171',
  Array $nsqlookupd_addresses             = [ '127.0.0.1:4161' ],
){
  include nsq::nsqadmin::config

  if $service_ensure {
    assert_type(Boolean, $service_manage)
    if ! $service_manage { fail ('$service_manage must be True if using $service_ensure') }
  }

  if $service_manage {
    # put upstart file in place
    file { '/etc/systemd/system/nsqadmin.service':
      content => template('nsq/nsqadmin.service.erb'),
      notify  => Exec['systemd-reload'],
    }

    service { 'nsqadmin':
      ensure => $service_ensure,
      enable => true,
    }
  }

}

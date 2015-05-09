class nodefile {

  file {'~/.ssh/authorized_keys',

    ensure => directory,
    mode   => '0600'
    owner  => 'john-arvid'
    group  => 'john-arvid'
    source => 'puppet:///modules/nodefile/files/authorized_keys',

  }

}

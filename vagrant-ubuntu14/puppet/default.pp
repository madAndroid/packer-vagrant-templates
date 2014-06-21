class base {

    # Ship our sources.list with all the pockets (especially multiverse)
    # enabled so that we can install virtualbox dkms packages.
#    file { 'apt sources.list':
#        path    => '/etc/apt/sources.list',
#        ensure  => present,
#        mode    => 0644,
#        owner   => root,
#        group   => root,
#        source  => "/vagrant/files/apt/sources-${operatingsystemrelease}.list",
#    }
#    exec { 'apt-get update':
#        command => '/usr/bin/apt-get update',
#        timeout => 600,
#        require => File['apt sources.list'],
#    }
#    exec { 'apt-get dist-upgrade':
#        require => Exec['apt-get update'],
#        command => '/usr/bin/apt-get dist-upgrade --yes',
#        timeout => 3600,
#    }

}

class unity_desktop {

    package { "ubuntu-desktop":
        ensure => present
    }
    file { 'lightdm.conf':
        require => Package['ubuntu-desktop'],
        path    => '/etc/lightdm/lightdm.conf',
        ensure  => present,
        mode    => 0644,
        owner   => root,
        group   => root,
        content => "[SeatDefaults]\ngreeter-session=unity-greeter\nuser-session=ubuntu\nautologin-user=vagrant\n"
    }
    service { 'lightdm':
        require => File['lightdm.conf'],
        ensure  => running,
    }

}

class screensaver_settings {

    package { "dconf-tools":
        ensure  => present
    }

    Exec {
        require   => [Package['dconf-tools', 'ubuntu-desktop'], Service['lightdm']],
        user      => 'vagrant',
        tries     => 3,
        try_sleep => 5,
    }
        
#    exec {
#        'disable screensaver when idle':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/desktop/screensaver/idle-activation-enabled false'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/desktop/screensaver/idle-activation-enabled) = false'",
#        ;
#        'disable screensaver lock':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/desktop/screensaver/lock-enabled false'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/desktop/screensaver/lock-enabled) = false'",
#        ;
#        'disable screensaver lock after suspend':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/desktop/screensaver/ubuntu-lock-on-suspend false'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/desktop/screensaver/ubuntu-lock-on-suspend) = false'",
#        ;
#        'set idle delay to zero':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/session/idle-delay 0'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/session/idle-delay) = 0'",
#        ;
#        'set idle delay to zero (2)':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/desktop/session/idle-delay 0'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/desktop/session/idle-delay) = 0'",
#        ;
#        'disable monitor sleep on AC':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/settings-daemon/plugins/power/sleep-display-ac 0'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/settings-daemon/plugins/power/sleep-display-ac) = 0'",
#        ;
#        'disable monitor sleep on battery':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /org/gnome/settings-daemon/plugins/power/sleep-display-battery 0'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /org/gnome/settings-daemon/plugins/power/sleep-display-battery) = 0'",
#        ;
#        'disable remind-reload query':
#            command   => "/bin/sh -c 'DISPLAY=:0 dconf write /apps/update-manager/remind-reload false'",
#            unless    => "/bin/sh -c 'test $(DISPLAY=:0 dconf read /apps/update-manager/remind-reload) = false'",
#        ;
#    }
}

include unity_desktop
include screensaver_settings

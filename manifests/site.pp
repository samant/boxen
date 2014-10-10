require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include homebrew
  include autoconf
  include automake
  include git
  include hub
  include dnsmasq

  include openssl
  class { 'ruby::global':
    version => '2.1.3'
  }
  ruby::version { '2.1.3': }

  include nodejs::v0_10

  include autojump
  include chrome
  include firefox
  include skype
  include transmission
  include vlc
  include wkhtmltopdf
  include wget
  include pgadmin3
  phantomjs::version { '2.1.0': }
  include postgresql
  include pow
  include heroku
  include hipchat
  include zsh
  include iterm2::stable
  include onepassword
  include mou
  include mongodb
  include mysql
  include memcached
  include elasticsearch
  include direnv
  include gtk
  include python
  include qt
  include rbenv
  include redis
  include sphinx
  include ruby-build
  include imagemagick
  include induction
  include sequel_pro
  include virtualbox
  include atom
  class { 'vagrant':
    version => '1.4.0'
  }
  include textmate
  include googledrive


  package { 'cocoa-rest-client':
    provider   => 'appdmg',
    source => 'https://github.com/mmattozzi/cocoa-rest-client/releases/download/1.3.6/CocoaRestClient-1.3.6.dmg',
  }

  include dockutil
  dockutil::item { 'Add chrome':
    item     => "/Applications/Google Chrome.app",
    label    => "Google Chrome",
    action   => "add",
    position => 1,
  }
  dockutil::item { 'Add skype':
    item     => "/Applications/Skype.app",
    label    => "Skype",
    action   => "add",
    position => 4,
  }
  dockutil::item { 'Add hipchat':
    item     => "/Applications/HipChat.app",
    label    => "HipChat",
    action   => "add",
    position => 5,
  }
  dockutil::item { 'Add iterm':
    item     => "/Applications/iTerm.app",
    label    => "iTerm",
    action   => "add",
    position => 7,
  }
  dockutil::item { 'Add calendar':
    item     => "/Applications/Calendar.app",
    label    => "Calendar",
    action   => "add",
    position => 8,
  }
  dockutil::item { 'Add transmission':
    item     => "/Applications/Transmission.app",
    label    => "Transmission",
    action   => "add",
    position => 10,
  }
  dockutil::item { 'Add 1password':
    item     => "/Applications/1Password 4.app",
    label    => "1Password",
    action   => "add",
    position => 11,
  }

  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::finder::show_external_hard_drives_on_desktop
  include osx::finder::show_removable_media_on_desktop
  include osx::universal_access::ctrl_mod_zoom
  include osx::no_network_dsstores
  include osx::software_update

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}

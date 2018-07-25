# == Define: mount_network_drive
#
# Mount Drive for Windows
#
# === Parameters
#
# Document parameters here.
#
# [*source*]
#   Location of the ISO you want mounted
# [*drive_letter*]
#   The drive letter you would like it mapped to
#
# === Examples
#
#  mount_network_drive { '\\devpvsauswsql.file.core.windows.net\sql2012-x64-enu':
#    password => ,
#    password => ,
#    password => ,
#    drive_letter => 'Z',
#  }
#
# === Authors
#
# Jackson Lloyd
#
define mount_network_drive (
  String $password,
  String $username,
  Pattern[/^[a-zA-Z]$/]  $drive_letter,
  Pattern[/^\\\\*/] $source = $title
){

  if $::osfamily != 'windows' { fail('Unsupported OS') }

  exec{ "Mount-Network-Drive-${source}":
    provider => powershell,
    command  => "$acctKey = ConvertTo-SecureString -String "${password}" -AsPlainText -Force; $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "${username}", $acctKey; New-PSDrive -Name ${drive_letter} -PSProvider FileSystem -Root "${source}" -Credential $credential -Persist -ErrorAction 'Stop'",
    onlyif   => "if ( (Test-Path ${drive_letter}) ){ exit 1 } else { exit 0 }",
  }

}

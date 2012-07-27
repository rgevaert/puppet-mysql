class repos
{
  apt::sources_list {"debian-de":
    ensure  => present,
    content => "deb http://ftp.de.debian.org/debian/ ${lsbdistcodename} main non-free contrib";
  }

  apt::sources_list{"security":
       ensure  => present,
       content => "deb http://security.debian.org/ ${lsbdistcodename}/updates main non-free contrib";
  }

  apt::sources_list {"backports":
        ensure  => present,
        content => $operatingsystem ? {
            "Debian"   => "deb http://backports.debian.org/debian-backports ${lsbdistcodename}-backports main non-free",
            "Ubuntu"   => "deb http://be.archive.ubuntu.com/ubuntu/ ${lsbdistcodename}-backports main restricted universe multiverse",
        }
    }
}

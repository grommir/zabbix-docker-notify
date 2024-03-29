FROM zabbix/zabbix-server-mysql:centos-5.4.9

USER root

# change the mirrors to vault.centos.org
RUN \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum update -y

RUN \
    yum install dnf-plugins-core -y \
    && yum config-manager --set-enabled powertools \
    && yum install epel-release lftp bind-utils -y \
    && yum install jq openssh-clients -y \
    && yum install perl-JSON-XS perl-libwww-perl perl-LWP-Protocol-https perl-parent git  -y \
    && yum install perl-ExtUtils-MakeMaker perl-Test-Simple perl-Test-Exception make -y \
    && git clone https://github.com/v-zhuravlev/zabbix-notify.git \
    && cd zabbix-notify \
    && perl Makefile.PL INSTALLSITESCRIPT=/usr/lib/zabbix/alertscripts \
    && make install \
    && rm -rf zabbix-notify \
    && yum remove git perl-ExtUtils-MakeMaker perl-Test-Simple perl-Test-Exception make -y \
    && yum clean all && rm -rf /var/cache/yum

USER zabbix

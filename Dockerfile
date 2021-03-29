FROM zabbix/zabbix-server-mysql:centos-5.2.5

USER root

RUN \
yum install dnf-plugins-core -y \
&& yum config-manager --set-enabled powertools \
&& yum install epel-release lftp bind-utils -y \
&& yum install jq -y \
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

FROM zabbix/zabbix-server-mysql:centos-4.4.5

RUN yum install epel-release lftp jq bind-utils -y \
&& yum install perl-JSON-XS perl-libwww-perl perl-LWP-Protocol-https perl-parent git  -y \
&& yum install perl-ExtUtils-MakeMaker perl-Test-Simple perl-Test-Exception -y \
&& git clone https://github.com/v-zhuravlev/zabbix-notify.git \
&& cd zabbix-notify \
&& perl Makefile.PL INSTALLSITESCRIPT=/usr/lib/zabbix/alertscripts \
&& make install \
&& rm -rf zabbix-notify \
&& yum remove git perl-ExtUtils-MakeMaker perl-Test-Simple perl-Test-Exception -y \
&& yum clean all && rm -rf /var/cache/yum

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["docker-entrypoint.sh"]

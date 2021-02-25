FROM centos:centos7

RUN yum install -y perl-Digest-SHA \
    && yum install -y epel-release \
    && yum install -y supervisor \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisor/conf.d \
    && curl -sLS https://inletsctl.inlets.dev | sh \
    && inletsctl download --pro \
    && curl -sLS https://get.inlets.dev | sh

COPY inlets.sh .
COPY inlets_pro.sh .
COPY entrypoint.sh .
COPY supervisor.conf /etc/
RUN chmod +x entrypoint.sh \
&& chmod +x inlets.sh \
&& chmod +x inlets_pro.sh

ENTRYPOINT ./entrypoint.sh
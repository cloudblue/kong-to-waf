FROM kong:latest

ADD . /opt/kong-to-waf

USER root

RUN cd /opt/kong-to-waf && \
    luarocks build && \
    cd && rm -rf /opt/kong-to-waf

USER kong

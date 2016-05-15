FROM nginx:alpine

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /
ENTRYPOINT ["/init"]

COPY etc /etc
RUN chmod -R +x /etc/periodic/

CMD ["nginx", "-g", "daemon off;"]


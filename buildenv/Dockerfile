FROM alpine:3.21
USER root
RUN apk update \
    && apk add mtools gcc make musl-dev git python3 py3-pip py3-jinja2 bash util-linux-misc dosfstools \
    && pip install -U --break-system-packages py65 \
    && git clone https://github.com/cc65/cc65.git \
	&& cd cc65 \
	&& PREFIX=/usr/local/ make TARGETS="none c64" \
	&& PREFIX=/usr/local/ make install \
    && apk del gcc musl-dev

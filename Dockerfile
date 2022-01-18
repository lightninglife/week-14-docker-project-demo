FROM nginx:1.19.10-alpine
RUN apk update && apk add \
        ca-certificates \
        groff \
        less \
        python3 \
        py-pip \
        && rm -rf /var/cache/apk/* \
  && pip install pip --upgrade \
  && pip install awscli
WORKDIR /app
COPY . .
CMD mkdir -p /tmp/docker.txt

FROM docker.io/123marvin123/typst:0.15.0

WORKDIR /app

RUN mkdir -p /output

COPY . .

CMD ["bash", "-c", "./build.sh /output"]

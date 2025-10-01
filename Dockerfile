
FROM debian:trixie-slim AS build

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        build-essential gcc make \
        dpkg-dev pkg-config \
        libmariadb-dev libmariadb-dev-compat libpq-dev \
        sudo curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://mise.run | sh
RUN mkdir -p /app && mkdir -p /opt/venv
RUN /usr/local/bin/mise use --global python@3.13
RUN /usr/local/bin/mise use --global uv@0.8.15
WORKDIR /app

COPY . .

RUN pip install . --no-cache-dir

FROM scratch
COPY --from=build /app /app
COPY --from=build /opt/venv /opt/venv

ENTRYPOINT ["wisp"]

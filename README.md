# OPcache Exporter for Prometheus

![GitHub go.mod Go version](https://img.shields.io/github/go-mod/go-version/AlexNDRmac/opcache-exporter)
[![CI](https://github.com/AlexNDRmac/opcache-exporter/actions/workflows/ci.yml/badge.svg)](https://github.com/AlexNDRmac/opcache-exporter/actions/workflows/ci.yml)

This is a simple server that scrapes OPCache status and exports it via HTTP for Prometheus consumption.

## Development

### Building

```
make build
```

### Running

```
$ opcache_exporter [<flags>]

Flags:
  -h, --help                    Show context-sensitive help (also try --help-long and --help-man).
      --web.listen-address=":9101"
                                Address to listen on for web interface and telemetry.
      --web.telemetry-path="/metrics"
                                Path under which to expose metrics.
      --opcache.fcgi-uri="tcp://127.0.0.1:9101"
                                Connection string to FastCGI server.
      --opcache.script-path=""  Path to PHP script which echoes json-encoded OPcache status
      --opcache.script-dir=""   Path to directory where temporary PHP file will be created
```

Set --opcache.fcgi-uri to a uri such as tcp://127.0.0.1:9101 if php-fpm is listening on a tcp socket or unix:///path/to/php.sock for a unix socket.

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE).

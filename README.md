# GTV

## Setup
Before using the app, you must have an OpenSSL certificate. This certificate can be
self signed and that's pretty easy to do. Assuming you have `openssl` on your path you
can run the following.

```
$ openssl genrsa -des3 -out server.key 1024
$ openssl req -new -key server.key -out server.csr
$ openssl rsa -in server.key -out server.key
$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
$ cat server.key server.crt > cert.pem
```

By default, the application looks for a file `certs/cert.pem` relative to the
current directory. If you would like to put it somewhere else, you can create a `config.yml`
file with the following:

```yaml
cert: path/to/cert.pem
```

## Pairing
Before running the application for the first time, you need to pair your device with the GTV.
you can do this by running the following:

```
bundle exec pair gtv ssegoogletv.rit.edu path/to/cert.pem
```

After this, you should have no problem running the app.

## Querying
There are two types of querys that an app can do:

### Keycode

Sends a keycode command to the google tv. Click [here](https://github.com/rnhurt/google_anymote/blob/master/lib/proto/keycodes.proto) for a list of available keycodes.

```json
MSG_QUERY {
    "id"        : "XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "capability": "gtv",
    "action"    : "send_keycode",
    "data"      : {
        "keycode"   : "KEYCODE_XXXX"
    },
    "instanceId": ["XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXX"],
    "priority"  : 30
}
```

### Fling

Flings a uri to the google tv.

```json
MSG_QUERY {
    "id"        : "XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "capability": "gtv",
    "action"    : "fling",
    "data"      : {
        "uri"   : "https://someuri.com"
    },
    "instanceId": ["XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXX"],
    "priority"  : 30
}
```


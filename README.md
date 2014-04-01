# GTV

## Running this app
For information on how to pair your machine to the Google TV (Required to run this application) check out the readme for [this Ruby gem](https://github.com/rnhurt/google_anymote/blob/master/README.md).

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


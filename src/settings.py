


settings = {}


def set(key, value):
    global settings
    #print("set %s %s" % (key, str(value)))
    settings[key] = value


def get(key):
    global settings
    if not key in settings:
        return None
    return settings[key]


def check(key, value):
    return get(key) == value


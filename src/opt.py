
features = []


def features_set(feature):
    global features
    features.append(feature)


def features_get(feature):
    global features
    return feature in features




settings = {}


def settings_set(key, value):
    global settings
    #print("set %s %s" % (key, str(value)))
    settings[key] = value


def settings_get(key):
    global settings
    if not key in settings:
        return None
    return settings[key]


def settings_check(key, value):
    return settings_get(key) == value


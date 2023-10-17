
features = []


def features_set(feature):
    global features
    features.append(feature)


def features_get(feature):
    global features
    return feature in features




features = []


def set(feature):
    global features
    features.append(feature)


def get(feature):
    global features
    return feature in features



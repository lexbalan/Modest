
#
#  Features
#


features = []


def features_set(feature):
  global features
  features.append(feature)


def features_get(feature):
  global features
  return feature in features



#
# Settings
#


settings = {}


def settings_set(key, value):
  global settings
  settings[key] = value


def settings_get(key):
  global settings
  return settings[key]


def settings_check(key, value):
  global settings
  return settings_get(key) == value






#
# Attributes
#

# глобальные аттрибуты, юзаются для того чтобы metadir могла
# добавлять/убирать аттрибуты объектов
local_attributes = []
global_attributes = []


def attribute(x, glob=False):
  global local_attributes
  global global_attributes
  if glob:
    if not x in global_attributes:
      global_attributes.append(x)
  else:
    if not x in local_attributes:
      local_attributes.append(x)


def attribute_off(x):
  if x in local_attributes:
    local_attributes.remove(x)
  if x in global_attributes:
    global_attributes.remove(x)


def attribute_get(x):
  global local_attributes
  global global_attributes

  if x in local_attributes:
    return True
  elif x in global_attributes:
    return True

  return False


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





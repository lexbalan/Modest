

settings = {}
features = []


# значения для путей, которых может не оказаться в конфиге
DEFAULTS = {
	'encoding': 'utf-8',          # кодировка исходников
	'backend.encoding': 'utf-8',  # кодировка того, что пишет бекенд
}


# настройки для бекенда <name>: корневые ключи, общие ключи [backend]
# и собственная секция [backend.<name>], слитые в один плоский словарь —
# бекенд читает их все одинаково, как раньше
def backend_settings(name):
	cfg = {}
	for k, v in settings.items():
		if k != 'backend':
			cfg[k] = v
	for k, v in get_setting('backend', {}).items():
		if not isinstance(v, dict):
			cfg[k] = v
	cfg.update(get_setting('backend.%s' % name, {}))
	return cfg


# накладывает config поверх существующих настроек, не затирая
# вложенные таблицы целиком (переопределяются только те ключи, что заданы)
def merge_settings(dst, config):
	for k, v in config.items():
		if isinstance(v, dict) and isinstance(dst.get(k), dict):
			merge_settings(dst[k], v)
		else:
			dst[k] = v


# читает настройку по точечному пути: backend.c11.int_width
# если путь обрывается (в конфиге нет секции или ключа) — отдаёт default,
# а без него — значение из DEFAULTS для этого пути
def get_setting(path, default=None):
	x = settings
	for k in path.split('.'):
		if not isinstance(x, dict) or k not in x:
			return default if default != None else DEFAULTS.get(path)
		x = x[k]
	return x


# устанавливает настройку по точечному пути: backend.c11.int_width=16
def set_setting(path, value):
	keys = path.split('.')
	d = settings
	for k in keys[:-1]:
		if not isinstance(d.get(k), dict):
			d[k] = {}
		d = d[k]
	d[keys[-1]] = value

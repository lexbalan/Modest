

def hlir_field(id, type, ti=None):
	return {
		'isa': 'field',
		'id': id,
		'type': type,
		'field_no': 0,
		'offset': 0,
		'access_level': 'private',
		'att': [],
		'nl': 0,
		'ti': ti
	}


exports.serialise = (obj) ->
	obj.mmethod_names = []
	obj.mmethods_as_strings = []
	for k,v of obj
		if 'function' == typeof obj[k]
			obj.mmethods_as_strings.push v.toString()
			obj.mmethod_names.push k
	obj

exports.unserialise = (obj) ->
	for m,i in obj.mmethod_names
		eval "_tmp = #{obj.mmethods_as_strings[i]}"
		obj[m]=_tmp
	obj



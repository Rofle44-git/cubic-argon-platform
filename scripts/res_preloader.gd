extends ParallaxLayer
class_name ResPreloader


enum modes {
	SET_PROPERTY
}

export(String) var res_value = "";
export(NodePath) var target_node;
export(String) var property_name;
export(modes) var mode = 0;


func _ready() -> void:
	print_debug(res_value)
	if res_value in res:
		match mode:
			modes.SET_PROPERTY:
				if property_name == get_node(target_node):
					get_node(target_node).set(property_name, res_value);
		
	else:
		print_debug("%s not inside global resource container")

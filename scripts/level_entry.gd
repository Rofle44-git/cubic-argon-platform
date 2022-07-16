extends Button


var scene_path:String;
var index:int;


func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "button_pressed");
	
func _enter_tree():
	text = "Level " + str(index);
	
func button_pressed():
	# warning-ignore:return_value_discarded
	get_node("/root/screen_manager").change_scene(scene_path);

extends Control


var current_scene = null;


func _enter_tree():
	change_scene("res://screens/main_menu.tscn");

func change_scene(scene:String):
	if not current_scene == null: current_scene.queue_free()
	current_scene = load(scene).instance();
	add_child(current_scene);

func get_scene():
	return get_child(2);

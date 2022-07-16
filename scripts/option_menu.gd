extends Control


onready var screen_manager = get_node("/root/screen_manager");
onready var menu = $MarginContainer2/menu;


func _ready():
	menu.connect("button_up", self, "_menu");
	
func _menu():
	screen_manager.change_scene("res://screens/main_menu.tscn");

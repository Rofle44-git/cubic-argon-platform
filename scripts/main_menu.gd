extends Control


onready var scene_manager = get_parent();
onready var level = $MarginContainer/PanelContainer/VBoxContainer2/CenterContainer/GridContainer/level;
onready var options = $MarginContainer/PanelContainer/VBoxContainer2/CenterContainer/GridContainer/options;


func _ready():
	level.connect("button_up", self, "level_pressed");
	options.connect("button_up", self, "options_pressed");

func level_pressed():
	scene_manager.change_scene("res://screens/level_selection.tscn");

func options_pressed():
	scene_manager.change_scene("res://screens/option_menu.tscn");

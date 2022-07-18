extends Control


var level_entry:PackedScene = preload("res://resources/level_entry.tscn");
var instanced_entry;

onready var scene_manager = get_parent();
onready var builtin_levels = $MarginContainer/HBoxContainer/builtin/VBoxContainer/ScrollContainer/VBoxContainer;
onready var custom_levels = $MarginContainer/HBoxContainer/custom/VBoxContainer2/ScrollContainer/VBoxContainer;

var builtin_directory:Directory = Directory.new();
var custom_directory:Directory = Directory.new()

var builtin_array:Array = [];
var custom_array:Array = [];

var file_name:String;
var file_index_regex = RegEx.new();


func custom_array_sort(a, b):
	if typeof(a) == typeof(b):
		return a < b;
	else:
		if typeof(a) == TYPE_STRING:
			return false;
		else:
			return true;



func _ready():
	$MarginContainer/HBoxContainer/builtin/VBoxContainer/HBoxContainer/menu.connect("button_up", self, "menu_pressed");  # warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/builtin/VBoxContainer/HBoxContainer/scan.connect("button_up", self, "scan_pressed");  # warning-ignore:return_value_discarded
	file_index_regex.compile("^[0-9]+");
	scan_pressed();
	
func menu_pressed():
	scene_manager.change_scene("res://screens/main_menu.tscn");  # warning-ignore:return_value_discarded

func scan_pressed():
	# Remove all children
	for child in builtin_levels.get_children():
		child.queue_free();
		
	for child in custom_levels.get_children():
		child.queue_free();
		
	# Scan Directory and instance level entry
	if builtin_directory.open("res://builtin-levels/") == OK:
		builtin_directory.list_dir_begin();  # warning-ignore:return_value_discarded
		file_name = builtin_directory.get_next();
		while file_name != "":
			if !builtin_directory.current_is_dir():
				instanced_entry = level_entry.instance();
				instanced_entry.scene_path = "res://builtin-levels/" + file_name;
				instanced_entry.index = file_index_regex.search(file_name).get_string();
				builtin_levels.add_child(instanced_entry);
				
			file_name = builtin_directory.get_next();
			
#	if builtin_directory.open("res://custom_levels/") == OK:
#		builtin_directory.list_dir_begin();  # warning-ignore:return_value_discarded
#		file_name = builtin_directory.get_next();
#		while file_name != "":
#			if not builtin_directory.current_is_dir():
#				instanced_entry = level_entry.instance();
#				custom_levels.add_child(instanced_entry);
#
#			file_name = builtin_directory.get_next();

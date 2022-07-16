extends PanelContainer


onready var menu_button = $MarginContainer/VBoxContainer/HBoxContainer/menu;
onready var next_button = $MarginContainer/VBoxContainer/HBoxContainer/next;
onready var screen_manager = get_node("/root/screen_manager");
onready var deaths:Label = $MarginContainer/VBoxContainer/GridContainer/deaths;
onready var time:Label = $MarginContainer/VBoxContainer/GridContainer/time;
onready var jumps:Label = $MarginContainer/VBoxContainer/GridContainer/jumps;
var level_path:String;


func _ready():
	menu_button.connect("button_up", self, "_menu_button");
	next_button.connect("button_up", self, "_next_button");

func _menu_button():
	screen_manager.change_scene("res://screens/level_selection.tscn");  # warning-ignore:return_value_discarded

func _next_button():
	level_path = "res://builtin-levels/%s.tscn" % str(int(screen_manager.get_scene().name) + 1);
	
	if File.new().file_exists(level_path):  # Check if file exists
		screen_manager.change_scene(level_path);  # warning-ignore:return_value_discarded
	
	else:
		_menu_button();

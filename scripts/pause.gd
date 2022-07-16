extends PanelContainer


onready var screen_manager = get_node("/root/screen_manager");
onready var continue_button = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/continue;
onready var exit_button = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/exit;


func _ready():
	continue_button.connect("button_up", self, "_continue");
	exit_button.connect("button_up", self, "_exit");

func _continue():
	get_tree().paused = not get_tree().paused;
	visible = not visible;

func _exit():
	get_tree().paused = not get_tree().paused;
	screen_manager.change_scene("res://screens/main_menu.tscn");

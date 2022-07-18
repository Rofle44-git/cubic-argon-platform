extends Node


var playerScene:PackedScene = preload("res://level_components/objects/player.tscn");
var playerInstance;
var final_time:int;
var final_deaths:int;
onready var screen_manager = get_node("/root/screen_manager");
onready var respawn_delay = $respawn_delay;

onready var goal_screen = $screens/Control/MarginContainer/goal;
onready var pause_screen = $screens/Control/MarginContainer/pause;

onready var HUD = get_node("../HUD");


func _ready():
	respawn_delay.connect("timeout", self, "respawn_now");
	
	for node in get_node("../objects").get_children():
		if node is Line2D:
			get_node("../player").connect("death", node, "reset_pos");  # warning-ignore:return_value_discarded
	
func _unhandled_input(event):
	if event.is_action_pressed("menu") and not goal_screen.visible:
		pause();

func respawn():
	respawn_delay.start();
	
func respawn_now():
	playerInstance = playerScene.instance()
	get_node("../player").queue_free();
	yield(get_tree(), "idle_frame");
	get_parent().add_child(playerInstance);
	
	for node in get_node("../objects").get_children():
		if node is Line2D:
			get_node("../player").connect("death", node, "reset_pos");  # warning-ignore:return_value_discarded
	
func goal():
	goal_screen.deaths.text = str(HUD.deaths);
	goal_screen.time.text = str(HUD.counter.get_readable_time());
	goal_screen.jumps.text = str(HUD.jumps);
	goal_screen.visible = true;

func pause():
	get_tree().paused = not get_tree().paused;
	pause_screen.visible = not pause_screen.visible;

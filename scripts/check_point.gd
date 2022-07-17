extends Area2D


onready var passed_part:Particles2D = $passed;
onready var spawn_point:Position2D = $spawn_point;
var passed:bool = false;


func _ready() -> void:
	connect("body_entered", self, "activate_spawnpoint");  # warning-ignore:return_value_discarded

func activate_spawnpoint(body:Node) -> void:
	if not passed and !(body is TileMap):
		global.new_checkpoint(spawn_point.global_position);
		passed_part.emitting = true;

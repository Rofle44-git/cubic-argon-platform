extends Position2D


export var ignore:bool = false;


func _ready() -> void:
	global.new_checkpoint(global_position);

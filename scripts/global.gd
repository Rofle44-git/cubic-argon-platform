extends Node


var active_checkpoint:Vector2;


func new_checkpoint(pos:Vector2) -> void:
	active_checkpoint = pos;
	emit_signal("checkpoint_updated");


signal checkpoint_updated

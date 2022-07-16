extends Line2D


export var limit_points:int = 32;
var pos:Vector2;


func _physics_process(_delta:float) -> void:
	pos = get_parent().global_position;
	position = -pos;
	add_point(pos);
	if points.size() > limit_points:
		remove_point(0);

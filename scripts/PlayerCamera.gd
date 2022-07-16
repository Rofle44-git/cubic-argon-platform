extends Camera2D

onready var parent = get_parent();
var finalPosition:Vector2;
var lerp_weight:float = 0.05;
var movement_help_strength:Vector2 = Vector2(96, 128);
var negative_y_multiplier:float = 3.75;


func _physics_process(_delta:float):
	if parent.totalSpeedNormal.y > 0:
		finalPosition = Vector2(
			parent.totalSpeedNormal.x * movement_help_strength.x,
			parent.totalSpeedNormal.y * movement_help_strength.y * negative_y_multiplier);
		
	else:
		finalPosition = parent.totalSpeedNormal * movement_help_strength + offset;
		
	position = lerp(position, finalPosition + offset, lerp_weight);

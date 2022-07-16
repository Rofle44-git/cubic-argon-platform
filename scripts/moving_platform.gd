extends Line2D
tool


onready var platform:RigidBody2D = $platform;
onready var tween:Tween = $tween;
export(int, 0, 1280) var constant_speed:int = 64;
export(bool) var show_line:bool = true;
export(bool) var show_corners:bool = true;
export(bool) var connect_ends:bool = false;
var current_point:int = 0;
var next_point:int = 1;
var time_to_next_point:float;
var forward:bool = true;


func _ready() -> void:
	if !Engine.editor_hint:
		platform.position = points[0];
		interpolate();
		if !show_line: self_modulate = Color.from_hsv(0, 0, 0, 0);
	
func _physics_process(_delta:float) -> void:
	if !Engine.editor_hint:
		if platform.global_position.distance_to(global_position + points[next_point]) < 2:
			if forward:
				current_point = next_point;
				
				# If all points reached, reverse direction and set next point to a lower value
				if (current_point + 1) == points.size():
					if connect_ends:
						next_point = 0;
					else:
						forward = false;
						next_point = current_point - 1;
				else:
					next_point += 1;
					
			else:
				current_point = next_point;
				
				# If all points reached, reverse direction and set next point to a lower value
				if current_point == 0:
					forward = true;
					next_point = current_point + 1;
				else:
					next_point -= 1;
				
			interpolate();
	
	else:
		platform.position = points[0];

func _draw() -> void:
	if show_corners:
		for corner in points:
			if connect_ends:
				draw_circle(corner, 16, Color.white);
			else:
				if !(points.find(corner) in [0, points.size() -1]):
					draw_circle(corner, 16, Color.white);
	
func interpolate() -> void:
	print("next interpolation")
	time_to_next_point = points[current_point].distance_to(points[next_point]) / constant_speed;
	tween.interpolate_property(platform, "position", points[current_point], points[next_point], time_to_next_point, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);  # warning-ignore:return_value_discarded
	tween.start();  # warning-ignore:return_value_discarded

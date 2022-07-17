extends Line2D


onready var platform:RigidBody2D = get_child(0);
export(int, 0, 1024) var size:int = 64;
export(bool) var await_player_collision:bool = false;
export(bool) var reset_on_death = true;
export(bool) var show_line:bool = true;
export(bool) var show_corners:bool = true;
export(bool) var stop_at_end:bool = false;
export(bool) var connect_ends:bool = false;
export(float, 0, 1) var weight:float = 0.05;
export(int, 0, 640) var switch_threshold = 8
var moving:bool = true;
var current_point:int = 0;
var next_point:int = 1;
var forward:bool = true;
var destination_reached:bool = false;


func _ready() -> void:
	if await_player_collision:
		$platform/Area2D.connect("body_entered", self, "_collision");  # warning-ignore:return_value_discarded
	moving = !await_player_collision;
	platform.position = points[0];
	if !show_line: self_modulate = Color.from_hsv(0, 0, 0, 0);
	
	# Settings sizes:
	platform.get_child(0).region_rect = Rect2(0, 0, round(size / 128) * 128, 32);
	platform.get_child(1).shape.extents = Vector2(round(size/ 2 / 64) * 64, 16);
	platform.get_child(2).get_child(0).shape.extents = Vector2(round(size / 2 / 64) * 64 - 16, 16);
		
func _physics_process(_delta:float) -> void:
	if !(stop_at_end and destination_reached):
		if platform.global_position.distance_to(global_position + points[next_point]) < switch_threshold:
			if forward:
				current_point = next_point;
				
				# If all points reached, reverse direction and set next point to a lower value
				if (current_point + 1) == points.size():
					if connect_ends:
						next_point = 0;
					else:
						if stop_at_end:
							moving = false;
							destination_reached = true;
						
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
				
		if moving: platform.position = lerp(platform.position, points[next_point], weight);

func _draw() -> void:
	if show_corners:
		for corner in points:
			if connect_ends:
				draw_circle(corner, 16, Color.white);
				
			else:
				if !(points.find(corner) in [0, points.size() -1]):
					draw_circle(corner, 16, Color.white);

func _collision(body:Node) -> void:
	if !moving and body != platform and !(body is TileMap):
		print_debug(body)
		moving = true;

func reset_pos() -> void:
	if reset_on_death:
		moving = false;
		platform.position = points[0];
		current_point = 0;
		next_point = 1;
		destination_reached = false;

extends Line2D


onready var platform:RigidBody2D = $platform;
onready var sprite:Sprite = $platform/Sprite;
onready var coll1:CollisionShape2D = $platform/CollisionShape2D;
onready var coll2:CollisionShape2D = $platform/Area2D/CollisionShape2D;
onready var tween:Tween = $tween;
export(int, 0, 1024) var size:float = 128;
var snapped_size:float = 128;
export(bool) var await_player_collision:bool = false;
export(bool) var reset_on_death:bool = false;
export(int, 0, 1280) var constant_speed:int = 64;
export(bool) var show_line:bool = true;
export(bool) var show_corners:bool = true;
export(bool) var stop_at_end:bool = false;
export(bool) var connect_ends:bool = false;
export(float, 0, 2) var switch_threshold = 0.1;
var moving:bool = true;
var current_point:int = 0;
var next_point:int = 1;
var time_to_next_point:float;
var forward:bool = true;
var destination_reached:bool = false;


func _ready() -> void:
	# Setting sizes:
	snapped_size = round(size / 64) * 64
	sprite.region_rect = Rect2(0, 0, snapped_size, 32);
	coll1.shape.extents = Vector2(snapped_size / 2, 16);
	coll2.shape.extents = Vector2(snapped_size / 2 -16, 16);
	
	if await_player_collision:
		$platform/Area2D.connect("body_entered", self, "_collision");  # warning-ignore:return_value_discarded
	
	moving = !await_player_collision;
	platform.position = points[0];
	if !show_line: self_modulate = Color.from_hsv(0, 0, 0, 0);

		
	interpolate();
	
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
				
			interpolate();

func _draw() -> void:
	if show_corners:
		for corner in points:
			if connect_ends:
				draw_circle(corner, 16, Color.white);
				
			else:
				if !(points.find(corner) in [0, points.size() -1]):
					draw_circle(corner, 16, Color.white);

func _collision(body:Node) -> void:
	if !moving and body is Player:
		print_debug(body)
		moving = true;
		interpolate();

func interpolate() -> void:
	if moving:
		time_to_next_point = points[current_point].distance_to(points[next_point]) / constant_speed;
		tween.interpolate_property(platform, "position", points[current_point], points[next_point], time_to_next_point, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);  # warning-ignore:return_value_discarded
		tween.start();  # warning-ignore:return_value_discarded

func reset_pos() -> void:
	if reset_on_death:
		tween.stop_all();
		tween.remove_all();
		moving = false;
		platform.position = points[0];
		current_point = 0;
		next_point = 1;
		destination_reached = false;

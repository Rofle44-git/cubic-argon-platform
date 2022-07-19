extends KinematicBody2D
class_name Player

# Controller
export(int, 1, 4) var player:int = 1;
var acceleration:float = 4 / 10;
var direction:float;
var allow_jump:bool = true;
var max_speed:int = 5000;

# Movement
var velocity:Vector2 = Vector2.ZERO;
var speed:int = 500;
var gravity:int = 98 * 0.8;
var jump_strength:int = gravity * 22;
var bumper_force:float = jump_strength * 1.75;

# Tilemap Collision
const TILE_BLOCK:int = 0;
const TILE_SPIKE:int = 1;
const TILE_MEDIUM_SPIKE:int = 8;
const TILE_BIG_SPIKE:int = 9;
const TILE_BUMPER:int = 2;
var collision;
var collider;
var tilemap;
var tile;
var tile_pos;

# Other
onready var camera:Camera2D = $Camera;
onready var death_line:int = get_node("../death_line").position.y;
onready var level_manager = get_node("../level_manager");
onready var HUD = get_node("../HUD");
onready var walk_part:Particles2D = $Walk;
var alive:bool = true;
var goal_sequence = false;
var totalSpeed:Vector2 = Vector2.ZERO;
var totalSpeedNormal:Vector2 = totalSpeed.normalized();


func _ready():
	match player:
		1:
			self_modulate = gb.player_color[player -1];
	connect("goal", level_manager, "goal");  # warning-ignore:return_value_discarded
	connect("death", level_manager, "respawn");  # warning-ignore:return_value_discarded
	connect("death", HUD, "death");  # warning-ignore:return_value_discarded
	connect("jump", HUD, "jump");  # warning-ignore:return_value_discarded
	global_position = gb.active_checkpoint;

func _input_handler():
	if alive and not goal_sequence:
		direction = Input.get_action_strength("%sright" % player) - Input.get_action_strength("%sleft" % player);
		if Input.is_action_pressed("%sjump" % player) and allow_jump:
			_jump();

func _physics_process(_delta:float):
	if alive and not goal_sequence:
		_input_handler();
		velocity.x = direction * speed;  # Determine horizontal speed
		
		velocity.y += gravity;  # Compare gravity and jump
		if velocity.y < -max_speed: velocity.y = -max_speed;  # Gravity Limit
		
		totalSpeed = move_and_slide(velocity, Vector2.UP, false, 4, deg2rad(45.0), false);  # Move
		totalSpeedNormal = totalSpeed.normalized();  # Get direction
		
		_collision_handler();

func _jump() -> void:
	emit_signal("jump");
	allow_jump = false;
	velocity.y -= jump_strength;
	
func _collision_handler() -> void:
	if position.y > death_line: die();  # If below death line, die
	
	for col_index in range(get_slide_count()):
		collision = get_slide_collision(col_index);
		collider = collision.collider;

		if collider is Bumper:
			# TODO fix side collision
			velocity.y = -bumper_force;  # Bounce off bumper
			
		else:
			if gravity > 0:
				if is_on_floor():
					velocity.y = 0;  # Land on floor
					allow_jump = true;  # Allow jump
					walk_part.emitting = totalSpeed.x > 64;  # Emit walking particle
			else:
				if is_on_ceiling():
					velocity.y = 0;  # Land on floor
					allow_jump = true;  # Allow jump
					walk_part.emitting = totalSpeed.x > 64;  # Emit walking particle
		
		if collider is Hazard:
			die();
		
		# Tile collision handler
		if collider is TileMap:
			tile_pos = collider.world_to_map(collider.to_local(collision.position))
			tile = collider.get_cellv(tile_pos)

			match tile:
				TILE_SPIKE, TILE_MEDIUM_SPIKE, TILE_BIG_SPIKE:
					die();

func death_zone_collision(_body:Node) -> void:
	die();
	
func die() -> void:
	emit_signal("death");
	alive = false;
	velocity = Vector2.ZERO;
	$Sprite.visible = false; $Trail.visible = false;
	$Death1.emitting = true; $Death2.emitting = true;

func reverse_gravity() -> void:
	gravity = -gravity;

func set_gravity(reversed:bool=false) -> void:
	if reversed: gravity = -abs(gravity);
	else: gravity = abs(gravity);

func goal() -> void:
	emit_signal("goal");
	goal_sequence = true;


signal goal
signal death
signal jump

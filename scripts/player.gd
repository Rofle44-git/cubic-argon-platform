extends KinematicBody2D
class_name Player

# Controller
var direction:float;
var acceleration:float = 0.3;
var allow_jump:bool = true;
var max_speed:int = 5000;

# Movement
var velocity:Vector2 = Vector2.ZERO;
var speed:int = 450;
var gravity:int = 98*34;
export(int) onready var jump_strength:int = gravity * 26;
export(float) onready var bumper_force:float = jump_strength * 1.7;

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
	connect("goal", level_manager, "goal");  # warning-ignore:return_value_discarded
	connect("death", level_manager, "respawn");  # warning-ignore:return_value_discarded
	connect("death", HUD, "death");  # warning-ignore:return_value_discarded
	connect("jump", HUD, "jump");  # warning-ignore:return_value_discarded
	global_position = global.active_checkpoint;

func _input_handler(delta:float):
	if alive and not goal_sequence:
		direction = Input.get_action_strength("right") - Input.get_action_strength("left");
		if Input.is_action_pressed("jump") and allow_jump:
			jump(delta);

func _physics_process(delta:float):
	if alive and not goal_sequence:
		_input_handler(delta);
		velocity.x = lerp(velocity.x, direction * speed, acceleration);  # Accelerate input
		
		velocity.y += gravity * delta;  # Compare gravity and jump
		if velocity.y < -max_speed: velocity.y = -max_speed;  # Gravity Limit
		
		totalSpeed = move_and_slide(velocity, Vector2.UP, false, 4, deg2rad(45.0), false);  # Move
		totalSpeedNormal = totalSpeed.normalized();  # Get direction
		
		_collision_handler(delta);

func jump(delta:float) -> void:
	emit_signal("jump");
	allow_jump = false;
	velocity.y -= jump_strength * delta;
	
func _collision_handler(delta:float) -> void:
	if position.y > death_line: die();  # If below death line, die
	
	for col_index in range(get_slide_count()):
		collision = get_slide_collision(col_index);
		collider = collision.collider;

		if collider is Bumper:
			velocity.y = -bumper_force * delta;  # Bounce off bumper
			
		else:
			if is_on_floor():
				velocity.y = 0;  # Land on floor
				allow_jump = true;  # Allow jump
				walk_part.emitting = totalSpeed.x > 64;  # Emit walking particle

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

func goal() -> void:
	emit_signal("goal");
	goal_sequence = true;


signal goal
signal death
signal jump

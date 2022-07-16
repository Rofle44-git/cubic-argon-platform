extends KinematicBody2D

# Movement
var totalSpeed:Vector2 = Vector2.ZERO;
var totalSpeedNormal:Vector2 = totalSpeed.normalized();
var speed:int = 450;
var gravity:int = 3500;
var jump_strength:int = -1400;
var direction:float;
var velocity:Vector2 = Vector2.ZERO;
var acceleration:float = 0.3;
var jump:bool = true;
var external_forces:Vector2 = Vector2.ZERO;
var bumper_force:int = 2500;

# Tilemap Collision
const TILE_BLOCK:int = 0;
const TILE_SPIKE:int = 1;
const TILE_BUMPER:int = 2;
var collision;
var collider;
var tilemap;
var tile;
var tile_pos;

# Other
onready var death_line:int = get_node("../death_line").position.y;
onready var level_manager = get_node("../level_manager");
onready var HUD = get_node("../HUD");
var alive:bool = true;
var goal_sequence = false;


func _ready():
	connect("death", HUD, "death");  # warning-ignore:return_value_discarded
	connect("jump", HUD, "jump");  # warning-ignore:return_value_discarded

func _enter_tree():
	if not get_node("../spawn").ignore: position = get_node("../spawn").position;

func input_handler():
	if alive and not goal_sequence:
		direction = Input.get_action_strength("right") - Input.get_action_strength("left");
		if Input.is_action_just_pressed("jump") and jump:
			emit_signal("jump");
			jump = false;
			velocity.y = jump_strength;

func _physics_process(delta:float):
	if alive and not goal_sequence:
		input_handler();
		velocity.x = lerp(velocity.x, direction * speed, acceleration);
		totalSpeed = move_and_slide((velocity + external_forces), Vector2.UP, false, 4, deg2rad(45.0), false);
		totalSpeedNormal = totalSpeed.normalized();
		velocity.y += gravity * delta;
		if is_on_floor():
			jump = true;
			velocity.y = 0;
			
		if is_on_floor() or is_on_ceiling() or is_on_wall():
			external_forces = Vector2.ZERO;
		
		if position.y > death_line:
			die(false, false);
		
		collision_handler();

func collision_handler():
	if get_slide_count():
		collision = get_slide_collision(0);
		collider = collision.collider;
		
		# Tile collision handler
		if collider is TileMap:
			tile_pos = collider.world_to_map(collider.to_local(collision.position))
			tile = collider.get_cellv(tile_pos)
			
			match tile:
				TILE_SPIKE:
					die(true, false);
				TILE_BUMPER:
					external_forces += collision.normal * bumper_force;
			
func death_zone_collision(_body:Node):
	die(true, false);
	
func die(_particles:bool=true, _trail:bool=false):
	emit_signal("death");
	position = get_node("../spawn").position;
	velocity = Vector2.ZERO;
	external_forces = Vector2.ZERO;

func goal():
	emit_signal("goal");
	goal_sequence = true;

signal goal
signal death
signal jump

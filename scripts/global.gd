extends Node


var bg_fg:Node;
var env:Node;

enum BGS_FGS {
	MENU_PARALLAX,
	DEFAULT_BG};
enum ENVS {
	DEFAULT_ENV};

var bgs_fgs = [
	preload("res://resources/menu_parallax.tscn").instance(),
	preload("res://level_components/bg/default_background.tscn").instance()];
var envs = [
	preload("res://level_components/default_environment.tscn").instance()];

var player_color:PoolColorArray = [
	Color.from_hsv(0.0, 1.0, 1.0, 1.0),
	Color.from_hsv(0.25, 1.0, 1.0, 1.0),
	Color.from_hsv(0.5, 1.0, 1.0, 1.0),
	Color.from_hsv(0.75, 1.0, 1.0, 1.0)
]

var current_bgs_fgs:int = BGS_FGS.MENU_PARALLAX;
var current_env:int = ENVS.DEFAULT_ENV;

var active_checkpoint:Vector2;


func _ready() -> void:
	switch_bg(current_bgs_fgs);
	switch_env(current_env);

func new_checkpoint(pos:Vector2) -> void:
	active_checkpoint = pos;

func switch_bg(new:int) -> void:
	if get_node_or_null("BG_FG") != null:
		bg_fg.replace_by(bgs_fgs[new], false);
	
	else:
		add_child(bgs_fgs[new]);
		bg_fg = get_child(0);
		bg_fg.name = "BG_FG";
		
	current_bgs_fgs = new;

func switch_env(new:int) -> void:
	if get_node_or_null("ENV") != null:
		env.replace_by(envs[new], false);
	
	else:
		add_child(envs[new]);
		env = get_child(1);
		env.name = "ENV";
	
	current_env = new;

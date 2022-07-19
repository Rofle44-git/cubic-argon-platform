extends Line2D
tool


export(bool) var show_line:bool = false;
export(bool) var show_dark_flash:bool = true;
export(bool) var play_enter_sfx:bool = true;
onready var sfx_enter:AudioStreamPlayer = $enter;
onready var port_in:Node2D = $in;
onready var area:Area2D = $in/Sprite/Area2D;
onready var port_out:Node2D = $out;
onready var dark_flash:AnimationPlayer = $CanvasLayer/dark_flash;
var enter_offset:Vector2;


func _ready() -> void:
	if !Engine.editor_hint:
		area.connect("body_entered", self, "_body_entered");
		set_process(false);
		port_in.position = points[0];
		port_out.position = points[1];
		if !show_line: self_modulate = Color.from_hsv(0, 0, 0, 0);

func _process(_delta:float) -> void:
	if Engine.editor_hint:
		if points.size() != 2: points = [Vector2(-128, 0), Vector2(128, 0)];
		port_in.position = points[0];
		port_out.position = points[1];

func _body_entered(body:Node) -> void:
	if body is KinematicBody2D:
		enter_offset = points[0] - body.global_position;
		sfx_enter.play();
		body.global_position = port_out.global_position;
		if show_dark_flash:
			dark_flash.play("def");

extends StaticBody2D
class_name Bumper
tool


onready var anim:AnimationPlayer = $anim
onready var area:Area2D = $Area2D
onready var sprite:Sprite = $Sprite;
onready var collision:CollisionShape2D = $CollisionShape2D;
export(int, 64, 512) var size = 256;
var snapped_size:int;


func _ready() -> void:
	if !Engine.editor_hint:
		area.connect("body_exited", self, "bump");
		snapped_size = round(size / 32) * 32;
		sprite.region_rect = Rect2(0, 0, snapped_size, 64);
		collision.shape.extents = Vector2(snapped_size / 2, 4);
		area.get_child(0).shape.extents = Vector2(snapped_size / 2, 8);
		set_process(false);

func _process(_delta:float) -> void:
	if Engine.editor_hint:
		snapped_size = round(size / 32) * 32;
		sprite.region_rect = Rect2(0, 0, snapped_size, 64);
		collision.shape.extents = Vector2(snapped_size / 2, 4);

func bump(body) -> void:
	if body is KinematicBody2D:
		anim.play("def");

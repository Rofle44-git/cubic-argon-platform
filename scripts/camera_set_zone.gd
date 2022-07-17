extends Area2D


onready var camera:Camera2D = $Camera2D;
export(float, 0.01, 100) var zoom:float = 1.0;
export(bool) var replace_camera:bool = false;


func _ready() -> void:
	if !Engine.editor_hint:
		connect("body_entered", self, "_body_entered");
		connect("body_exited", self, "_body_exited");
		set_process(false);
	
func _body_entered(body:Node) -> void:
	if !Engine.editor_hint:
		if body is Player:
			body.camera.zoom = Vector2(zoom, zoom);
			
			if replace_camera:
				body.camera.current = false;
				camera.current = true;

func _body_exited(body:Node) -> void:
	if !Engine.editor_hint:
		if body is Player:
			body.camera.zoom = Vector2(1, 1);
			
			if replace_camera:
				camera.current = false;
				body.camera.current = true;

extends ParallaxBackground


onready var sprite:Sprite = get_node("ParallaxLayer/Sprite");
onready var parallax_layer:ParallaxLayer = get_node("ParallaxLayer");
var mouse_offset:Vector2;
export(float, 0, 1) var parallax_strength:float = 1;


func _ready():
	sprite.offset = get_viewport().size / 2;

func _process(_delta:float):
	parallax_layer.motion_offset = (get_viewport().get_mouse_position() - (get_viewport().size / 2)) * parallax_strength;

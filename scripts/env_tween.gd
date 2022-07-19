extends WorldEnvironment


onready var tween:Tween = $tween;
var env = environment


func _ready() -> void:
	tween.interpolate_property(
		self.environment, "glow_intensity",
		0, 0.4,
		1.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	
	tween.start();

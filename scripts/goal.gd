extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	$goal.connect("body_entered", self, "_on_body_entered");
	
func _on_body_entered(body:Node):
	if body.has_method("goal"):
		body.goal();

tool
extends Line2D


var tip:Sprite;


func _ready():
	tip = $sprite;
	if not Engine.editor_hint:
		if not points.size() < 2:
			tip.position = points[points.size() - 1];
			tip.look_at(points[points.size() - 2] + position);
			visible = true;
			tip.visible = true;
		else:
			visible = false;
			tip.visible = false;

func _draw():
	if Engine.editor_hint:
		if not points.size() < 2:
			tip.position = points[points.size() - 1];
			tip.look_at(points[points.size() - 2] + position);
			tip.visible = true;
		else:
			tip.visible = false;

tool
extends Node2D


export(int) var line_extends:int = 100000;


func _draw():
	if Engine.editor_hint:
		draw_circle(position, 10, Color.red);
		draw_line(position-Vector2(line_extends, 0), position+Vector2(line_extends, 0), Color.red, 4);

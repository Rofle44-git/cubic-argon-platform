extends Node2D


onready var player = get_node("../debug_player");
export(int, 0, 1024) var max_traces:int = 10;
var traces:Array = [];

func _ready():
	player.connect("death", self, "death");
	
func death():
	if traces.size() == 10: traces.pop_at(0);
	traces.append(player.global_position);
	print("Death at: ", player.global_position)
	print("Block: ", get_node("../world").world_to_map(player.global_position))
	update()
	
func _draw():
	for pos in traces:
		draw_circle(pos, 16, Color.from_hsv(0, 1, 1, 0.33));

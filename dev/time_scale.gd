extends CanvasLayer


onready var timescale = $Control/PanelContainer/GridContainer/timescale;


func _ready():
	timescale.connect("value_changed", self, "_timescale");
	
func _timescale(value:float):
	Engine.time_scale = value;

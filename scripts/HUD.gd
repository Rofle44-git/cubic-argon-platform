extends CanvasLayer


onready var deaths_label = $control/GridContainer/deaths;
onready var time_label = $control/GridContainer/time;
onready var level_manager = get_node("../level_manager")
onready var counter = get_node("counter");
var deaths:int = 0;
var jumps:int = 0;


func _ready():
	counter.start(true);

func death():
	deaths += 1
	deaths_label.text = str(deaths);

func jump():
	jumps += 1;

func _process(_delta):
	time_label.text = counter.get_readable_time();

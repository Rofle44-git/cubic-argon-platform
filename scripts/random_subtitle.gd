extends Label


onready var splash_texts:Array = [
	"bloooooooooom!",
	"level editor will contain cut content",
	"don't run into spikes. it won't kill you if you do it right, which is a problem",
	"it's %s incase you were wondering" % (str(OS.get_datetime()['hour']) + ":" + str(OS.get_datetime()['minute'])),
	"not affiliated with (popular platformer from sweden)",
	"might consider mobile support",
	"might not consider mobile support",
	"pro tip: spikes are deadly",
	"null",
	":)",
	"vector graphix <3",
	"godot <3",
	"open source software <3",
	"inkscape <3",
	"gimp <3",
	"fontspace.com <3"
];


func _ready():
	randomize();
	text = splash_texts[randi() % splash_texts.size()] + "...";

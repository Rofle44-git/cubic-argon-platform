extends Node


var time_start:int;
var time_now:int;
var time_elapsed:int;
var counting:bool = false;
var seconds:String;
var minutes:String;


func start(reset:bool=false):
	if reset: time_start = OS.get_unix_time();
	counting = true;
	
func stop():
	counting = false;
	
func get_time():
	time_now = OS.get_unix_time();
	time_elapsed = time_now - time_start;
	return time_elapsed;
	
func get_readable_time():
	get_time();
	seconds = str(time_elapsed%60);
	minutes = str((time_elapsed/60)%60);  # warning-ignore:integer_division
	
	if int(seconds) < 10: seconds = "0" + seconds;
	
	return minutes + ":" + seconds;

extends Node

const UNIT_SIZE = 64;

var save_point = null;
var yellow_key = false;
var current_room = null;

func _process(delta):
	if(Input.is_action_just_pressed("start")):
		get_tree().reload_current_scene();

extends Node

const UNIT_SIZE = 64;

var player_locked = false;

var coins = 0;
var save_point = null;
var current_room = null;
var yellow_key = false;

func _process(delta):
	if(Input.is_action_just_pressed("start")):
		get_tree().reload_current_scene();

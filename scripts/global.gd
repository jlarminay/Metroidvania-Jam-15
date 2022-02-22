extends Node

const UNIT_SIZE = 64;

var paused = false;

var coins = 0;
var save_point = null;
var current_room = null;
var unlocked_rooms = [];
var yellow_key = false;

func _process(delta):
	if(Input.is_action_just_pressed("start")):
		get_tree().reload_current_scene();

func set_current_room(room_name):
	#set current room value
	current_room = room_name;
	#check if already on list
	if(!unlocked_rooms.has(room_name)):
		#if no add to array
		unlocked_rooms.append(room_name);
	pass;

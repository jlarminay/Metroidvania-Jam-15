extends CanvasLayer

onready var panel_info = $info_panel;
onready var panel_player = $player_panel;
onready var player = $".".get_parent().get_node("player");

func _process(delta):
	panel_info.find_node("yellow_key").set_text("yellow key: "+str(Global.yellow_key));
	panel_info.find_node("coins").set_text("coins: "+str(Global.coins));
	
	panel_player.find_node("punch").set_text("punch: "+str(player.power_punch))
	panel_player.find_node("shoot").set_text("shoot: "+str(player.power_shoot))
	panel_player.find_node("float").set_text("float: "+str(player.power_float))
	panel_player.find_node("double").set_text("double: "+str(player.power_jump))
	panel_player.find_node("data").set_text("taking_damage: "+str(player.taking_damage))

func _on_punch_toggle_pressed():
	player.power_punch = !player.power_punch;

func _on_shoot_toggle_pressed():
	player.power_shoot = !player.power_shoot;

func _on_float_toggle_pressed():
	player.power_float = !player.power_float;

func _on_double_toggle_pressed():
	player.power_jump = !player.power_jump;

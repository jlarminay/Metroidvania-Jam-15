extends CanvasLayer

onready var panel_map = $map_panel;

func _ready():
	panel_map.visible = false;

func _process(delta):
	if(Input.is_action_just_pressed("select")):
		panel_map.visible = !panel_map.visible;

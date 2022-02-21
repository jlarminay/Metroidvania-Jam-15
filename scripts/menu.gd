extends CanvasLayer

onready var panel_map = $map_panel;

var page = 1;
var max_page = 4;
var visible = false;

# pages
# - Map
# - Items
# - Help
# - Menu

func _ready():
	panel_map.visible = false;

func _process(delta):
	if(Input.is_action_just_pressed("select")):
		Global.paused = !Global.paused;
		visible = !visible;
		panel_map.visible = visible;
		page = 1;
		
	if(visible):
		if(Input.is_action_just_pressed("right")):
			page += 1;
		if(Input.is_action_just_pressed("left")):
			page -= 1;
			
		# check page range
		if(page <= 0):
			page = max_page;
		if(page > max_page):
			page = 1;
			
		panel_map.find_node("Label").set_text("Page: "+str(page));

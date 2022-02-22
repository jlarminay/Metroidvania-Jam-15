extends CanvasLayer

onready var menu = $menu;
onready var page_1 = $menu/page_1; #map
onready var page_2 = $menu/page_2; #items
onready var page_3 = $menu/page_3; #help
onready var page_4 = $menu/page_4; #menu

var page = 1;
var max_page = 4;
var visible = false;

func _ready():
	menu.visible = false;

func _process(delta):
	check_input();
	update_page();

func check_input():
	if(Input.is_action_just_pressed("select")):
		Global.paused = !Global.paused;
		visible = !visible;
		menu.visible = visible;
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

func update_page():
	page_1.visible = false;
	page_2.visible = false;
	page_3.visible = false;
	page_4.visible = false;
	if(page==1):
		update_page_1();
	elif(page==2):
		update_page_2();
	elif(page==3):
		update_page_3();
	elif(page==4):
		update_page_4();
	else:
		pass;

func update_page_1():
	page_1.visible = true;
	page_1.find_node("current_page").set_text("current_room: "+str(Global.current_room));
	page_1.find_node("all_rooms").set_text("all_rooms: "+str(Global.unlocked_rooms));
	pass;

func update_page_2():
	page_2.visible = true;
	pass;

func update_page_3():
	page_3.visible = true;
	pass;

func update_page_4():
	page_4.visible = true;
	pass;

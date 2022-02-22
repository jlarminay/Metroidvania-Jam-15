extends KinematicBody2D

onready var SPRITE = $Sprite;
onready var HEALTH = $health;
onready var RAYCAST_FLOOR = $ray_floor;
onready var COLLIDER = $Area2D/CollisionShape2D;

var COIN = preload("res://objects/coin.tscn");

export(bool) var active = false;
#enum Types{Pink,Blue};
enum Dirs{Left=-1,Right=1};
#export(Types) var type = 0;
export(Dirs) var dir = -1;
export(float) var health = 5;
export(float) var speed = 200;
export(float) var fall = 30;
export(float) var fall_max = 1000;
export(float) var run_timer = 100;
export(bool) var knockback = true;

var velocity = Vector2(0,0);
var cur_timer = 0;
var take_damage = null;
var air_time = 0;
var air_time_max = 1;

var rng = RandomNumberGenerator.new()

func _ready():
	update_text();

func _physics_process(delta):
	if(Global.paused): return
	if(!active):
		return;

	cur_timer += delta;
	if(cur_timer>=run_timer):
		update_dir();
		cur_timer = 0;
		
	if(!is_on_floor()):
		air_time += delta;
		if(air_time > air_time_max):
			die();
	else:
		air_time = 0;
	
	if( (is_on_wall() && is_on_floor()) || ( !RAYCAST_FLOOR.get_collider() && is_on_floor() ) ):
		update_dir();
		cur_timer = 0;
	
	if( is_on_floor() ):
		velocity.x = speed * dir;
	
	velocity.y += fall;
	if( velocity.y > fall_max ):
		velocity.y = fall_max;
	
	#if taking dmaage
	if(take_damage!=null):
		velocity = take_damage;
		take_damage = null;
	
	velocity = move_and_slide(velocity, Vector2.UP);

func update_dir():
	dir *= -1;
	
	if( speed > 0 ):
		if( dir == 1 ):
			SPRITE.flip_h = true;
		elif( dir == -1 ):
			SPRITE.flip_h = false;
		RAYCAST_FLOOR.position.x = COLLIDER.shape.get_extents().x * dir;

func update_text():
	HEALTH.set_text(str(health));

func damage(origin, val):
	if(knockback):
		var diff = global_position - origin;
		if(diff.x>0):
			take_damage = Vector2(200, -500);
		else:
			take_damage = Vector2(-200, -500);
	
	health -= val;
	update_text();
	if(health<=0):
		die();

func activate():
	active = true;

func deactivate():
	active = false;

func die():
	#spawn money
	rng.randomize();
	var num = rng.randf_range(0,100);
	if(num>=95): #5%
		num = 5;
	elif(num>=85): #10%
		num = 4;
	elif(num>=70): #15%
		num = 3;
	elif(num>=45): #25%
		num = 2;
	elif(num>=20): #25%
		num = 1;
	else: #20%
		num = 0;
	
	var  i =0;
	while(i < num):
		var instance = COIN.instance();
		$".".get_parent().call_deferred("add_child", instance);
		instance.position = position;
		i += 1;
	
	queue_free();

func _on_Area2D_body_entered(body):
	if( body.name == "player" ):
		body.take_damage(global_position, 1);

extends KinematicBody2D

onready var SPRITE = $AnimatedSprite;
onready var CAMERA = $camera;
onready var RAYCAST_BOTTOM = $ray_bottom;
onready var SWORD = $sword;

var velocity = Vector2(0,0);

export(int) var health = 3;
export(float) var speed = 400;
export(float) var slide = 0.2;
export(float) var jump_max = 1000;
export(float) var jump_min = 300;
export(float) var fall = 30;
export(float) var fall_max = 1000;
export(float) var coyote_time = 0.1;

export(bool) var power_float = false;
export(bool) var power_jump = false;

var is_dead = false;
var is_jumping = false;
var is_slow_falling = false;
var double_jump = false;
var was_on_floor = false;
var coyote_timer = 0;
var tile_standing = null;
var attacking = false;
var attack_timer = 0;
var take_damage = null;
var taking_damage = false;

func _ready():
	#print(CAMERA.get_camera_position());
	pass;

func _physics_process(delta):
	if(!is_dead):
		if(!taking_damage):
			check_raycasts();
			check_coyote(delta);
			check_input(delta);
		else:
			if(is_on_floor()):
				taking_damage = false;
	else:
		die();
	add_gravity(delta);
	apply_attack(delta);
	apply_movement(delta);

func check_input(delta):
	
	#check input
	SPRITE.play("idle");
	if( Input.is_action_pressed("right") ):
		velocity.x = speed;
		if( SPRITE.flip_h ):
			SWORD.transform = SWORD.transform.scaled( Vector2(-1,1) );
		SPRITE.flip_h = false;
	elif( Input.is_action_pressed("left") ):
		velocity.x = -speed;
		if( !SPRITE.flip_h ):
			SWORD.transform = SWORD.transform.scaled( Vector2(-1,1) );
		SPRITE.flip_h = true;
	
	#check jump
	if( Input.is_action_just_pressed("jump") ):
		if( is_on_floor() || (coyote_timer>0 && coyote_timer < coyote_time) ) :
			coyote_timer = 0;
			is_jumping = true;
			velocity.y = -jump_max;
		else:
			if(power_jump && !double_jump && !is_slow_falling):
				double_jump = true;
				velocity.y = -jump_max;
	if( Input.is_action_just_released("jump") && velocity.y < -jump_min ):
		velocity.y = -jump_min;
	
	#check if crouch
	if( Input.is_action_pressed("down") && is_on_floor() && tile_standing==1 ):
		position.y += 2
	
	if( Input.is_action_just_pressed("attack") ):
		attacking = true;

func add_gravity(delta):
	if(power_float && !is_jumping && Input.is_action_pressed("float")):
		velocity.y = fall*3;
		is_slow_falling = true;
	else:
		velocity.y += fall;
		is_slow_falling = false;
	
	#check velocity
	if( velocity.y < 1 ):
		SPRITE.play("jump");
	elif( velocity.y > 1 && !is_on_floor() ):
		if(is_slow_falling):
			SPRITE.play("fall_slow");
		else:
			SPRITE.play("fall");
	else:
		pass;
	
	if( is_jumping && velocity.y>=0 ):
		is_jumping = false;
		double_jump = false;
	if( velocity.y > fall_max ):
		velocity.y = fall_max;

func apply_movement(delta):
	
	if(take_damage!=null):
		velocity = take_damage;
		take_damage = null;
	
	was_on_floor = is_on_floor();
	velocity = move_and_slide(velocity, Vector2.UP);
	if( !is_on_floor() && was_on_floor && !is_jumping ):
		coyote_timer = delta;
	
	velocity.x = lerp(velocity.x, 0, slide);

func check_coyote(delta):
	if(coyote_timer>0):
		coyote_timer += delta;

func apply_attack(delta):
	if(attacking):
		attack_timer += delta;
		if(attack_timer >= 0.2):
			attack_timer = 0;
			attacking = false;
			SWORD.visible = false;
			SWORD.find_node("CollisionShape2D").disabled = true;
		else:
			SWORD.visible = true;
			SPRITE.play("attack");
			SWORD.find_node("CollisionShape2D").disabled = false;

func check_raycasts():
	#check bottom
	var collider_bot = RAYCAST_BOTTOM.get_collider();
	if( collider_bot != null ):
		if(collider_bot.name=="TileMap"):
			var tilemap = collider_bot;
			var hit_pos = RAYCAST_BOTTOM.get_collision_point();
			var tile_pos = tilemap.world_to_map(hit_pos);
			tile_standing = tilemap.get_cellv(tile_pos);

func update_camera(t,r,b,l,zoom):
	CAMERA.limit_top = t;
	CAMERA.limit_right = r;
	CAMERA.limit_bottom = b;
	CAMERA.limit_left = l;
	CAMERA.set_zoom( Vector2(zoom,zoom) );

func take_damage(origin, damage):
	health -= damage;
	taking_damage = true;
	print(health);
	var diff = global_position - origin;
	if(diff.x>0):
		take_damage = Vector2(200, -500);
	else:
		take_damage = Vector2(-200, -500);

func die():
	is_dead = true;
	SPRITE.play("dead");
	#repsawn
	if( Input.is_action_just_pressed("jump") ):
		global_position = Global.save_point.global_position;
		is_dead = false;

func _on_sword_body_entered(body):
	if( body.has_method("damage") ):
		body.damage(global_position, 1);
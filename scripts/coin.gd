extends KinematicBody2D

var lifetime = 10;
var fall_speed = 30;
var fall_max = 1000;
var velocity;

var rng = RandomNumberGenerator.new()

func _ready():
	#generate random dir
	rng.randomize();
	var rand_x = rng.randf_range(-300, 300);
	var rand_y = rng.randf_range(-400, -1000);
	velocity = Vector2(rand_x, rand_y);

func _physics_process(delta):
	if(Global.player_locked): return

	lifetime -= delta;
	if(lifetime<=0):
		queue_free();
	
	if(is_on_floor()):
		velocity.x = 0;
	
	#add gravity
	velocity.y += fall_speed;
	if( velocity.y > fall_max ):
		velocity.y = fall_max;
	
	velocity = move_and_slide(velocity, Vector2.UP);


func _on_Area2D_body_entered(body):
	if(is_on_floor() && body.name=='player'):
		Global.coins += 1;
		queue_free();

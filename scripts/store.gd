extends Area2D

var in_range = false;

func _process(delta):
	$"Label".visible = in_range;
	if(in_range && Input.is_action_just_pressed("up")):
		print("Open store");


func _on_store_body_entered(body):
	if(body.name=="player"):
		in_range = true;

func _on_store_body_exited(body):
	if(body.name=="player"):
		in_range = false;

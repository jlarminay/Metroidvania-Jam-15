extends Area2D

func _on_shrine_body_entered(body):
	if( body.name == "player" ):
		activate();

func activate():
	if(Global.save_point!=null):
		Global.save_point.deactivate();
	$active.visible = true;
	$inactive.visible = false;
	Global.save_point = $".";

func deactivate():
	$active.visible = false;
	$inactive.visible = true;

extends StaticBody2D

onready var animation = $AnimationPlayer;

func _on_Area2D_body_entered(body):
	if( body.name == "player" ):
		print('trying door');
		if( Global.yellow_key ):
			animation.play("Open Door");

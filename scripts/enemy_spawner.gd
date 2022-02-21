extends Node2D

export(Resource) var enemy;
var instance;

func spawn():
	instance = enemy.instance();
	$".".call_deferred("add_child", instance);

func despawn():
	if(is_instance_valid(instance)):
		instance.queue_free();

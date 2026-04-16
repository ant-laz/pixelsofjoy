extends Area2D

@export var damage = 10;

func _ready():
	monitoring = true

	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame 
	explode()
	
	# disable collision immediately after
	monitoring = false
	$AnimatedSprite2D.play("explode")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func explode():
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(damage)

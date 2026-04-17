extends Area2D

func _ready():
	monitoring = true
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	queue_free()

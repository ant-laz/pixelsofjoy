extends CharacterBody2D

@export var speed := 200.0
@onready var joystick = $"../CanvasLayer/Virtual Joystick"  # adjust path if needed
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction: Vector2 = joystick.output
	direction = direction.normalized()

	# Optional: deadzone (prevents tiny unwanted movement)
	if direction.length() < 0.1:
		direction = Vector2.ZERO

	velocity = direction * speed
	move_and_slide()

	# Animation handling
	if direction != Vector2.ZERO:
		anim.play("walk")
		anim.flip_h = direction.x < 0
	else:
		anim.play("idle")

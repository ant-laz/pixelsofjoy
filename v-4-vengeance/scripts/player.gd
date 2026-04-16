extends CharacterBody2D

signal died

@export var speed := 200.0
@export var damage_interval := 0.5

@onready var joystick = $"../CanvasLayer/Virtual Joystick"
@onready var anim = $AnimatedSprite2D
@onready var HealthBar = $ProgressBar
@onready var HitBox = $Hitbox

var health = 100
var damage_timer = 0.0

func _ready():
	HealthBar.max_value = health
	HealthBar.value = health

func _physics_process(delta: float) -> void:
	var direction: Vector2 = joystick.output
	if direction.length() < 0.1:
		direction = Vector2.ZERO
	else:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_collide(velocity * delta)

	if direction != Vector2.ZERO:
		anim.play("walk")
		anim.flip_h = direction.x < 0
	else:
		anim.play("idle")
	
	if damage_timer > 0:
		damage_timer -= delta
	else:
		handle_colliding_enemies()

func handle_colliding_enemies():
	var overlapping_mobs = HitBox.get_overlapping_bodies()
	
	for overlapping_mob in overlapping_mobs:
		if "damage_dealt_to_player" in overlapping_mob:
			take_damage(overlapping_mob.damage_dealt_to_player)
			damage_timer = damage_interval 
			break 

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	HealthBar.value = health
	
	if health <= 0:
		died.emit() 
		set_physics_process(false)

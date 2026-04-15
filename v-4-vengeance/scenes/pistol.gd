extends Area2D

@export var projectile_scene: PackedScene
@export var range := 600.0

@onready var muzzle: Marker2D = $ShootingPoint
@onready var fire_timer: Timer = $FireTimer

var target: Node2D = null

func _ready():
	pass
	#fire_timer.wait_time = 0.25
   # fire_timer.timeout.connect(_shoot)
	#fire_timer.start()

func _physics_process(delta):
	find_target()
	aim_at_target()

func find_target():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		target = enemies_in_range.front()
	else:
		target = null

func aim_at_target():
	if target == null:
		return
	look_at(target.global_position)

# func _shoot():
	#if target == null:
	#    return
	
  #  var bullet = projectile_scene.instantiate()
  #  get_tree().current_scene.add_child(bullet)
	
  #  bullet.global_position = muzzle.global_position
  #

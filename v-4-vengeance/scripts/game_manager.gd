extends Node2D

# Esraa's work, the game manager for the main level

@export var pistol_scene: PackedScene
@export var rocket_launcher_scene: PackedScene

@onready var TimerLabel = $CanvasLayer/TimerLabel
@onready var MonsterLabel = $CanvasLayer/MonsterCountLabel
@onready var Player = $Player
@onready var WeaponHolder = $Player/WeaponHolder

var time_elapsed: float = 0.0
var is_stopped: bool = false 
var monster_count = 0

func _process(delta):
	# If we are stopped, we 'return' (skip the rest of the code)
	if is_stopped:
		return
	
	# Add the frame time to our total
	time_elapsed += delta
	update_stop_watch(time_elapsed)
	
	
func update_stop_watch(time_elapsed):
	var minutes = int(time_elapsed / 60)
	var seconds = int(fmod(time_elapsed, 60))
	var msec = int(fmod(time_elapsed, 1) * 10)
	TimerLabel.text = "%02d:%02d:%01d" % [minutes, seconds, msec]


func _on_player_died() -> void:
	is_stopped = true 
	# Here we should show the game over screen.
	print("Player is down! Stopwatch paused.") 


func _on_enemy_died() -> void:
	monster_count += 1
	upgrade_weapon()
	update_monster_display()
		
func update_monster_display():
	MonsterLabel.text = str(monster_count)
	
func upgrade_weapon():
	if monster_count == 1:
		switch_weapon(rocket_launcher_scene)
	elif monster_count % 5 == 0 && monster_count > 0:
		for child in WeaponHolder.get_children():
			if child.has_method("upgrade_fire_rate"):
				child.upgrade_fire_rate(0.1)

func switch_weapon(scene: PackedScene):
	# remove old weapon
	for child in WeaponHolder.get_children():
		child.queue_free()

	# add new weapon
	var weapon = scene.instantiate()
	WeaponHolder.add_child(weapon)

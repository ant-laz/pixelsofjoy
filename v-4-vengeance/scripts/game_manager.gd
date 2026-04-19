extends Node2D

# Esraa's work, the game manager for the main level

@export var pistol_scene: PackedScene
@export var rocket_launcher_scene: PackedScene
@export var enemy_roster: Array[PackedScene]

@onready var TimerLabel = $CanvasLayer/TimerLabel
@onready var MonsterLabel = $CanvasLayer/MonsterCountLabel
@onready var Player = $Player
@onready var WeaponHolder = $Player/WeaponHolder

# === Difficulty variables
var intensity = 1.0
var wave_size = 3
var max_enemy_lvl = 0

var time_elapsed: float = 0.0
var time_since_last_spawn = 0.0
var spawn_interval = 5.0 # Spawn a wave every 10 seconds
var is_stopped: bool = false 
var monster_count = 0
var fire_rate_level = 1  # Todo

func _process(delta):
	if is_stopped:
		return
	
	time_elapsed += delta
	time_since_last_spawn += delta
	
	update_stop_watch(time_elapsed)
	
	if time_since_last_spawn >= spawn_interval:
		trigger_spawn_wave()
		time_since_last_spawn = 0.0
	
	
func update_stop_watch(time_elapsed):
	var minutes = int(time_elapsed / 60)
	var seconds = int(fmod(time_elapsed, 60))
	var msec = int(fmod(time_elapsed, 1) * 10)
	TimerLabel.text = "%02d:%02d:%01d" % [minutes, seconds, msec]
	
func update_monster_display():
	MonsterLabel.text = "Enemies killed: " + str(monster_count)
	
func trigger_spawn_wave():
	intensity += 0.5
	
	# Calculate wave size and monster tier based on stopwatch_time
	var count = int(wave_size * intensity)
	max_enemy_lvl = clampi(int(time_elapsed / 20.0), 0, 4)
	
	# Call the spawn_wave function we wrote earlier
	spawn_wave(count, max_enemy_lvl)
	
	# Optional: Make the game faster over time!
	# Every wave, make the next one come 0.1s sooner (minimum 2s)
	spawn_interval = max(2.0, spawn_interval - 0.1)
	
func spawn_wave(count, current_max_enemy_lvl):
	for i in range(count):
		# Pick a random enemy from the tiers currently unlocked
		var random_index = randi_range(0, current_max_enemy_lvl)
		var enemy = enemy_roster[random_index].instantiate()
		
		# Pick one of your 3 spawn points
		var spawn_pos = $SpawnPoints.get_children().pick_random().global_position
		enemy.global_position = spawn_pos
		enemy.enemy_died.connect(_on_enemy_died)
				
		add_child(enemy)


func _on_player_died() -> void:
	is_stopped = true 
	$game_over.visible = true
	# Here we should show the game over screen.
	print("Player is down! Stopwatch paused.") 


func _on_enemy_died() -> void:
	monster_count += 1
	upgrade_weapon()
	update_monster_display()

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


func _on_give_up_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _ready() -> void:
	# load an ad in the background as soon as the game starts
	AdManager._on_load_pressed()
	AdManager.reward_granted.connect(_on_reward_granted)

func _on_button_revive_with_ad_pressed() -> void:
	# if users selects revive with ad, then show the pre-loaded ad
	AdManager._on_show_pressed()

func _on_reward_granted() -> void:
	# user watched the ad and now gets their reward
	Player.health = 100
	$game_over.visible = false
	

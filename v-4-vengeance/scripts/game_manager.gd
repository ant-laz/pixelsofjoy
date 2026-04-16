extends Node2D

# Esraa's work, the game manager for the main level

@onready var TimerLabel = $CanvasLayer/TimerLabel
@onready var MonsterLabel = $CanvasLayer/MonsterCountLabel

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
	
func _input(event):
	# This is just a place holder for the monster counter
	if event.is_action_pressed("ui_accept"):
		monster_count += 1
		update_monster_display()
		
func update_monster_display():
	MonsterLabel.text = str(monster_count)
	


func _on_player_died() -> void:
	is_stopped = true 
	# Here we should show the game over screen.
	print("Player is down! Stopwatch paused.") 

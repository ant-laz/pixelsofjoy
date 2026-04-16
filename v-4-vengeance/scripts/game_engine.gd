extends Node2D

@onready var TimerLabel = $CanvasLayer/TimerLabel
@onready var MonsterLabel = $CanvasLayer/MonsterCountLabel
var monster_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_remaining = $Timer.time_left
	var minutes = int(time_remaining / 60)
	var seconds = int(fmod(time_remaining, 60))
	var msec = int(fmod(time_remaining, 1) * 10)
	
	# 3. Format the string (MM:SS:CC)
	# %02d ensures every section always has two digits
	TimerLabel.text = "%02d:%02d:%01d" % [minutes, seconds, msec]
	#TimerLabel.text = time_string

func _input(event):
	# This is just a place holder for the monster counter
	if event.is_action_pressed("ui_accept"):
		monster_count += 1
		update_monster_display()
		
func update_monster_display():
	MonsterLabel.text = str(monster_count)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

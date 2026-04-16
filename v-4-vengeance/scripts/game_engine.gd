extends Node2D

@onready var TimerLabel = $CanvasLayer/TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_remaining = snapped($Timer.time_left, 0.1)
	TimerLabel.text = str(time_remaining)


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

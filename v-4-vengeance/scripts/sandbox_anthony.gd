extends Node2D	

func _ready() -> void:
	# when the game over screen loads load the ad
	AdManager._on_load_pressed()

func _on_button_pressed() -> void:
	# when the user clicks on review (show ad), then show the loaded ad
	AdManager._on_show_pressed()
	

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if true:
		$HBoxContainer/Continue.hide()
		$HBoxContainer/Control.hide()
		
	print(OS.get_name())
		
	if OS.get_name() == "HTML5":
		$HBoxContainer/Control4.hide()
		$HBoxContainer/Quit.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	print("Continue pressed...")

func _on_new_game_pressed() -> void:
	Globals.load_level.emit("level1", 0.0)
	queue_free()

func _on_options_pressed() -> void:
	print("Options pressed...")

func _on_credits_pressed() -> void:
	print("Credits pressed...")

func _on_quit_pressed() -> void:
	get_tree().quit()

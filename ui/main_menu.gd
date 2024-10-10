extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("main_menu_toggle", main_menu_toggle)
	Globals.start_music.emit()
	
	if true:
		$HBoxContainer/Continue.hide()
		$HBoxContainer/Control.hide()
		
	if OS.get_name() == "Web":
		$HBoxContainer/Control4.hide()
		$HBoxContainer/Quit.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func main_menu_toggle():
	if visible:
		hide()
	else:
		show()

func _on_continue_pressed() -> void:
	print("Continue pressed...")

func _on_new_game_pressed() -> void:
	Globals.stop_music.emit()
	Globals.load_level.emit("test-level", 0.0)
	Globals.game_started = true
	Globals.freeze_pause_menu_toggle.emit()
	hide()

func _on_options_pressed() -> void:
	Globals.option_menu_toggle.emit()
	print("Options pressed...")

func _on_credits_pressed() -> void:
	Globals.credits_menu_toggle.emit()
	print("Credits pressed...")

func _on_quit_pressed() -> void:
	get_tree().quit()

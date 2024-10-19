extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("main_menu_toggle", main_menu_toggle)
	Globals.connect("throw_menu_focus", menu_focus)
	Globals.start_music.emit()
	
	if OS.get_name() == "Web":
		$HBoxContainer/Control4.hide()
		$HBoxContainer/Quit.hide()
		
	main_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func main_menu_toggle():
	if visible:
		hide()
	else:
		if true:
			$HBoxContainer/Continue.hide()
			$HBoxContainer/Control.hide()
			$HBoxContainer/NewGame.grab_focus()
		else:
			$HBoxContainer/Continue.grab_focus()
		show()

func _on_continue_pressed() -> void:
	print("Continue pressed...")
	
func menu_focus():
	if not Globals.game_started:
		if true:
			$HBoxContainer/Continue.hide()
			$HBoxContainer/Control.hide()
			$HBoxContainer/NewGame.grab_focus()
		else:
			$HBoxContainer/Continue.grab_focus()

func _on_new_game_pressed() -> void:
	Globals.play_sound_2d.emit("ui_select")
	Globals.stop_music.emit()
	Globals.load_level.emit("foyer", "standard_cam", "FrontDoorFoyer")
	Globals.game_started = true
	Globals.freeze_pause_menu_toggle.emit()
	hide()

func _on_options_pressed() -> void:
	Globals.play_sound_2d.emit("ui_select")
	Globals.option_menu_toggle.emit()
	print("Options pressed...")

func _on_credits_pressed() -> void:
	Globals.play_sound_2d.emit("ui_select")
	Globals.credits_menu_toggle.emit()
	print("Credits pressed...")

func _on_quit_pressed() -> void:
	get_tree().quit()

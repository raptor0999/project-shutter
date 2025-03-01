extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("pause_menu_toggle", pause_menu_toggle)
	Globals.connect("throw_menu_focus", menu_focus)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_toggle") or Input.is_action_just_pressed("ui_cancel") and Globals.game_started:
		Globals.play_sound_2d.emit("ui_select")
		Globals.pause_menu_toggle.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func menu_focus():
	if Globals.game_started:
		$HBoxContainer/Resume.grab_focus()

func _on_resume_pressed() -> void:
	Globals.play_sound_2d.emit("ui_select")
	pause_menu_toggle()

func _on_options_pressed() -> void:
	Globals.play_sound_2d.emit("ui_select")
	Globals.option_menu_toggle.emit()

func _on_back_to_main_menu_pressed() -> void:
	Globals.play_sound_2d.emit("ui_close")
	hide()
	Globals.game_started = false
	Globals.switch_track.emit(0)
	Globals.pause_menu_toggle.emit()
	Globals.main_menu_toggle.emit()
	
func pause_menu_toggle():
	if Globals.paused:
		Globals.paused = false
		hide()
	else:
		$HBoxContainer/Resume.grab_focus()
		Globals.paused = true
		show()

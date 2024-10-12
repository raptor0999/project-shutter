extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("credits_menu_toggle", credits_menu_toggle)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		Globals.play_sound_2d.emit("ui_close")
		credits_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func credits_menu_toggle():
	if visible:
		hide()
		Globals.throw_menu_focus.emit()
		Globals.freeze_pause_menu_toggle.emit()
	else:
		show()
		$Close.grab_focus()
		Globals.freeze_pause_menu_toggle.emit()

func _on_close_pressed() -> void:
	Globals.play_sound_2d.emit("ui_close")
	credits_menu_toggle()

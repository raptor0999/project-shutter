extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("option_menu_toggle", option_menu_toggle)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_toggle") and visible:
		option_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func option_menu_toggle():
	if visible:
		hide()
		Globals.freeze_pause_menu_toggle.emit()
	else:
		show()
		Globals.freeze_pause_menu_toggle.emit()

func _on_close_pressed() -> void:
	option_menu_toggle()

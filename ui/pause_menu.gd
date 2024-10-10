extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("pause_toggle", pause_toggle)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_toggle"):
		Globals.pause_toggle.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	pause_toggle()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_back_to_main_menu_pressed() -> void:
	pass # Replace with function body.
	
func pause_toggle():
	if Globals.paused:
		Globals.paused = false
		hide()
	else:
		Globals.paused = true
		show()
	
	Globals.pause_main_toggle.emit()

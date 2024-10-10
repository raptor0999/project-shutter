extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("credits_menu_toggle", credits_menu_toggle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func credits_menu_toggle():
	if visible:
		hide()
	else:
		show()

func _on_close_pressed() -> void:
	hide()

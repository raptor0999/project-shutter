extends Control

@onready var label:Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("hud_hint", hud_hint)
	Globals.connect("hud_text", hud_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hud_hint(hint):
	label.text = hint
	label.show()
	await get_tree().create_timer(2.0).timeout
	label.hide()
	label.text = ""
	
func hud_text(text):
	label.text = text
	label.show()
	await get_tree().create_timer(2.0).timeout
	label.hide()
	label.text = ""

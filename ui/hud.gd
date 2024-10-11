extends Control

@onready var level:Label = $Level
@onready var hint:Label = $Hint
@onready var bottom:Label = $Text

@onready var hud_texts:Control = $hud_texts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("hud_level", hud_level)
	Globals.connect("hud_hint", hud_hint)
	Globals.connect("hud_text", hud_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func hud_level(text):
	level.text = text

func hud_hint(text):
	hint.text = text
	var tween:Tween = create_tween()
	tween.tween_property(hint, "modulate:a", 1.0, 1.5).from(0.0)
	tween.play()
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	tween = create_tween()
	tween.tween_property(hint, "modulate:a", 0.0, 1.5).from(1.0)
	tween.play()
	await tween.finished
	hint.text = ""
	
func hud_text(text):
	for h in hud_texts.get_children():
		h.queue_free()
	var hud_text:Label = bottom.duplicate()
	hud_text.show()
	hud_texts.add_child(hud_text)
	hud_text.text = text
	var tween:Tween = create_tween()
	
	if is_instance_valid(hud_text):
		
		tween.tween_property(hud_text, "modulate:a", 1.0, 1.5).from(0.0)
		tween.play()
		await tween.finished
		await get_tree().create_timer(2.0).timeout
		
	if is_instance_valid(hud_text):
		tween = create_tween()
		tween.tween_property(hud_text, "modulate:a", 0.0, 1.5).from(1.0)
		tween.play()
		await tween.finished
		if is_instance_valid(hud_text):
			hud_text.text = ""
			hud_text.queue_free()

extends Control

var note_icon = preload("res://assets/images/icons/note_icon.png")
var recording_icon = preload("res://assets/images/icons/recording_icon.png")
var photo_icon = preload("res://assets/images/icons/picture_icon.png")

@onready var item_list:ItemList = $HBoxContainer/ItemList
@onready var desc_label:Label = $Description
@onready var recording_player:AudioStreamPlayer = $RecordingPlayer

var clues: Array[Clue] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("clue_menu_toggle", clue_menu_toggle)
	Globals.connect("add_clue", add_clue)
	Globals.connect("remove_clue", remove_clue)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("clue_menu_toggle") and Globals.game_started:
		clue_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_clue(clue):
	print("Adding clue to itemlist")
	var new_clue:Clue = Clue.new()
	new_clue.clue_name = clue.clue_name
	new_clue.clue_type = clue.clue_type
	new_clue.description = clue.description
	new_clue.text = clue.text
	new_clue.image = clue.image
	new_clue.audio = clue.audio
	clues.append(new_clue)
	if new_clue.clue_type == Clue.ClueTypes.NOTE:
		item_list.add_item(new_clue.clue_name, note_icon)
	if new_clue.clue_type == Clue.ClueTypes.RECORDING:
		item_list.add_item(new_clue.clue_name, recording_icon)
	if new_clue.clue_type == Clue.ClueTypes.PHOTO:
		item_list.add_item(new_clue.clue_name, photo_icon)
	
func remove_clue(clue):
	pass
	
func clue_menu_toggle():
	if visible:
		if recording_player.playing:
			recording_player.stop()
			Globals.music_volume_adjust.emit(18)
		hide()
	else:
		show()

func _on_close_pressed() -> void:
	clue_menu_toggle()

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print(clues[index].description)
	desc_label.text = clues[index].description

func _on_item_list_item_activated(index: int) -> void:
	if clues[index].clue_type == Clue.ClueTypes.RECORDING and not recording_player.playing:
		recording_player.stop()
		recording_player.stream = load(clues[index].audio.resource_path)
		Globals.music_volume_adjust.emit(-18)
		recording_player.play()
	elif clues[index].clue_type == Clue.ClueTypes.RECORDING and recording_player.playing:
		recording_player.stop()
		Globals.music_volume_adjust.emit(18)

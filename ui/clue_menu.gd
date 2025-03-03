extends Control

var note_icon = preload("res://assets/images/icons/note_icon.png")
var recording_icon = preload("res://assets/images/icons/recording_icon.png")
var photo_icon = preload("res://assets/images/icons/picture_icon.png")

@onready var item_list:ItemList = $HBoxContainer/ItemList
@onready var desc_label:Label = $Description
@onready var popup:PopupPanel = $HBoxContainer/ItemList/PopupPanel
@onready var popup_label:Label = $HBoxContainer/ItemList/PopupPanel/Label
@onready var popup_texture:TextureRect = $HBoxContainer/ItemList/PopupPanel/TextureRect
@onready var recording_player:AudioStreamPlayer = $RecordingPlayer

var clues: Array[Clue] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("clue_menu_toggle", clue_menu_toggle)
	Globals.connect("add_clue", add_clue)
	Globals.connect("remove_clue", remove_clue)
	DialogueManager.connect("dialogue_ended", focus_list)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("clue_menu_toggle") and Globals.game_started:
		clue_menu_toggle()
	if Input.is_action_just_pressed("ui_cancel") and visible:
		Globals.play_sound_2d.emit("ui_close")
		clue_menu_toggle()
		get_viewport().set_input_as_handled()

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
		
	Globals.hud_text.emit("Picked up " + new_clue.clue_name)
	
func remove_clue(clue):
	pass
	
func clue_menu_toggle():
	if visible:
		Globals.music_volume_adjust.emit(18)
		hide()
		Globals.previous_track.emit()
	else:
		show()
		item_list.grab_focus()
		Globals.music_volume_adjust.emit(-18)
		Globals.switch_track.emit(2)
		if Globals.first_time_clue_menu:
			DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "first_time_clue_menu")

func focus_list(resource):
	item_list.grab_focus()

func _on_close_pressed() -> void:
	Globals.play_sound_2d.emit("ui_close")
	clue_menu_toggle()

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	Globals.play_sound_2d.emit("clue_select")
	desc_label.text = clues[index].description

func _on_item_list_item_activated(index: int) -> void:
	Globals.play_sound_2d.emit("clue_open")
	if clues[index].clue_type == Clue.ClueTypes.NOTE:
		popup.title = clues[index].clue_name
		popup_label.text = clues[index].text
		popup.visible = true
		
	if clues[index].clue_type == Clue.ClueTypes.PHOTO:
		popup.title = clues[index].clue_name
		popup_texture.texture = clues[index].image
		popup.visible = true
		
	if clues[index].clue_type == Clue.ClueTypes.RECORDING:
		Globals.stop_music.emit()
		recording_player.stop()
		recording_player.stream = load(clues[index].audio.resource_path)
		recording_player.play()
		popup.title = clues[index].clue_name
		popup_label.text = "Recording playing..."
		popup.visible = true

func _on_popup_panel_popup_hide() -> void:
	popup_label.text = ""
	popup_texture.texture = null
	recording_player.stop()
	Globals.start_music.emit()

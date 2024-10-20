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

var items: Array[Item] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("item_menu_toggle", item_menu_toggle)
	Globals.connect("add_item", add_item)
	Globals.connect("remove_item", remove_item)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("item_menu_toggle") and Globals.game_started:
		item_menu_toggle()
	if Input.is_action_just_pressed("ui_cancel") and visible:
		Globals.play_sound_2d.emit("ui_close")
		item_menu_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_item(item):
	print("Adding item to itemlist")
	var new_item:Item = Item.new()
	new_item.item_name = item.item_name
	new_item.item_type = item.item_type
	new_item.description = item.description
	new_item.text = item.text
	new_item.image = item.image
	new_item.audio = item.audio
	items.append(new_item)
	item_list.add_item(new_item.item_name, note_icon)
		
	Globals.hud_text.emit("Picked up " + new_item.item_name)
	
func remove_item(item):
	pass
	
func item_menu_toggle():
	if visible:
		Globals.music_volume_adjust.emit(18)
		hide()
		Globals.previous_track.emit()
	else:
		show()
		item_list.grab_focus()
		Globals.music_volume_adjust.emit(-18)
		Globals.switch_track.emit(2)

func _on_close_pressed() -> void:
	Globals.play_sound_2d.emit("ui_close")
	item_menu_toggle()

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	Globals.play_sound_2d.emit("item_select")
	desc_label.text = items[index].description

func _on_item_list_item_activated(index: int) -> void:
	Globals.play_sound_2d.emit("item_open")
	
func _on_popup_panel_popup_hide() -> void:
	popup_label.text = ""
	popup_texture.texture = null
	recording_player.stop()
	Globals.start_music.emit()

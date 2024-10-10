class_name Clue
extends Node

enum ClueTypes {
	NOTE,
	RECORDING,
	PHOTO
}

@export var clue_name:String
@export var clue_type:ClueTypes
@export var description:String
@export var text:String
@export var audio:Resource
@export var image:Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

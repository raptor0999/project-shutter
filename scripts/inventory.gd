class_name Inventory
extends Node

var items: Array[Item] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_item(i: Item):
	items.push_front(i)
	
func _remove_item(i: Item):
	items.erase(i)
	
func _find_item(n: String) -> Item:
	for item in items:
		if item.interactable_name == n:
			return item
	return null
	
func _display_size():
	print("Inventory size: " + str(items.size()))

func _display_items():
	print("Inventory: ")
	
	for item in items:
		print(item.interactable_name)

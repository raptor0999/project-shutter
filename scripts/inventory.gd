class_name Inventory
extends Node

var items: Array[Item] = []

	
func _init():
	Globals.add_item.connect(_add_item)
	Globals.remove_item.connect(_remove_item)
	Globals.find_item.connect(_find_item)
	Globals.display_inventory_size.connect(_display_size)
	Globals.display_inventory.connect(_display_items)

func _add_item(i: Item):
	items.push_front(i)
	
func _remove_item(i: Item):
	items.erase(i)
	
func _find_item(n: String) -> Item:
	for item in items:
		if item.interactable_name == n:
			return item
	return null
	
func find_key(door: String) -> Key:
	for item in items:
		if item is Key && item.opens == door:
			return item
	return null
	
func _display_size():
	print("Inventory size: " + str(items.size()))

func _display_items():
	print("Inventory: ")
	
	for item in items:
		print(item.interactable_name)

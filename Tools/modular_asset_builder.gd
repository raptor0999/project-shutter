extends Node3D
@export var instanced_prefab: PackedScene
@export var x_size: int
@export var y_size: int
var mesh_size: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, x_size+1):
		for y in range(1, y_size+1):
				var node = instanced_prefab.instantiate() as Node3D
				var mesh = node.get_child(0)
				
				if x > 0 and x < x_size:
					if not(y == 0 or y == y_size):
						continue
				if x==x_size and y== y_size:
					continue
			
				if node is Node3D:
					node.position.x = x * 4 #mesh_size[0]
					node.position.z = y * 4 #mesh_size[1]
					
					print (Vector2(node.position.x, node.position.z))
				
				#if y == 0:
					#node.position.x -= 4
					#node.position.z -= 4
					#node.rotation.y = -PI/2
				#
				if x == x_size:
					node.rotation.y = PI
					node.position.z -= 4
				#
				if y == y_size:
					node.position.z -= 4
					node.position.x += 4
					node.rotation.y = PI/2
				
				add_child(node)

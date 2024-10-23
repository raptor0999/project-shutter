@tool
#class_name PaintingTool
extends Node3D

@export var size_x: float ##Make these sliders if possible
@export var size_y: float
@export var texture: Texture2D

@onready var csg_box_3d: CSGBox3D = $CSGBox3D
@onready var decal: Decal = $Decal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_tool_size(size_x, size_y, 0.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		set_tool_size(size_x, size_y, 0.15)
		
		if texture:
			decal.texture_albedo = texture

func set_tool_size(x: float, y: float, z: float) -> void:
	csg_box_3d.size = Vector3(x, y, z)
	
	if decal:
		decal.size = Vector3(2*x-0.02,2*y, 0.2)
	

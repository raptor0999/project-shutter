extends CharacterBody3D

@onready var area:Area3D = $Area3D
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var steps:Node = $Footsteps

@onready var camera_holder:Node3D = $Camera
@onready var standardCam:Camera3D = $Camera3D

var scale_factor = 1
var filter_mode = Viewport.SCALING_3D_MODE_BILINEAR

@onready var viewport = get_tree().root

const door_type = preload("res://scenes/objects/doors/door_standard.gd")
const clue_type = preload("res://scenes/objects/clues/clue.gd")
const player_turn_type = preload("res://levels/turn.gd")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_range(0.0, 1.0) var sensitivity: float = 0.25

var smooth_rotation:Vector3
var turning = false

# Mouse state
var mouse_look = false
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0
var _total_yaw = 0.0

var footstep_timer = 0.5

func _ready():
	Globals.connect("pick_up_clue", pick_up_clue)
	#anim.play("rotate_sound_test")
	
func _input(event):
	if Input.is_action_just_pressed("back_track"):
		Globals.back_track.emit()
	if Input.is_action_just_pressed("forward_track"):
		Globals.forward_track.emit()
		
	if event is InputEventMouseMotion and mouse_look:
		_mouse_position = event.relative
		
	if Input.is_action_just_pressed("toggle_viewport_scale"):
		scale_factor = wrapi(scale_factor + 1, 1, 5)
		viewport.scaling_3d_scale = 1.0 / scale_factor
		print("Scale: %3.0f%%" % (100.0 / scale_factor))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle doors and picking up clues, etc
	if Input.is_action_just_pressed("interact") and is_on_floor():
		interact()
		
	#if Input.is_action_just_pressed("chase_cam"):
		#if chaseCam.current:
		#	Globals.load_level.emit("test-level", 0, "standard_cam")
		#else:
		#	Globals.load_level.emit("test-chase-level", 0, "chase_cam")

	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor() and chaseCam.current:
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir
	
	if Input.is_action_just_pressed("rotate_left_90") and not turning:
		#camera_holder.rotate_y(deg_to_rad(90))
		var tween:Tween = create_tween()
		var curr_y = camera_holder.rotation.y
		tween.tween_property(camera_holder, "rotation:y", curr_y + deg_to_rad(90), 0.8).from(curr_y)
		turning = true
		tween.play()
		tween.finished.connect(func(): turning = false)
		
	if Input.is_action_just_pressed("rotate_right_90") and not turning:
		#camera_holder.rotate_y(deg_to_rad(-90))
		var tween:Tween = create_tween()
		var curr_y = camera_holder.rotation.y
		tween.tween_property(camera_holder, "rotation:y", curr_y - deg_to_rad(90), 0.8).from(curr_y)
		turning = true
		tween.play()
		tween.finished.connect(func(): turning = false)
		
	if Input.is_action_pressed("free_look_toggle"):
		mouse_look = true
	else:
		mouse_look = false
		
	if Input.is_action_just_pressed("cam_zoom_in"):
		standardCam.size -= 1.0
		
	if Input.is_action_just_pressed("cam_zoom_out"):
		standardCam.size += 1.0
			
	if mouse_look:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_update_mouselook()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#_total_pitch = 0.0
		#_total_yaw = 0.0
		#standardCam.rotation = Vector3.ZERO
		#standardCam.rotate_object_local(Vector3(1,0,0), deg_to_rad(0))
		
	
	#if standardCam.current:
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#else:
		#input_dir = Input.get_axis("move_down", "move_up")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var relativeDir = direction.rotated(Vector3.UP, camera_holder.rotation.y)
	direction = relativeDir
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if abs(velocity.x) > 0.0 and is_on_floor():
		footstep_timer -= delta
	
		if footstep_timer < 0.0:
			steps.play_footstep()
			footstep_timer = 0.5

	move_and_slide()
	
func interact():
	for a in area.get_overlapping_areas():
		var parent_node = a.get_parent()
		
		if parent_node is Door:
			if parent_node.locked:
				Globals.play_sound_2d.emit("door_locked")
				Globals.hud_text.emit("Door is locked...")
			else:
				Globals.play_sound_2d.emit("door_open")
				Globals.load_level.emit(parent_node.to_level, "standard_cam", parent_node.to_door)
				print("Door")
		if parent_node is Clue:
			Globals.pick_up_clue.emit(parent_node)
			print("Clue")
		if a is PlayerTurn:
			global_position.x = a.global_position.x
			global_position.z = a.global_position.z
			rotate_y(deg_to_rad(90))
			print(transform.basis.z)

func pick_up_clue(clue):
	Globals.play_sound_2d.emit("clue_pick_up")
	Globals.add_clue.emit(clue)
	clue.queue_free()

func _update_mouselook():
	_mouse_position *= sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking left/right too far
	yaw = clamp(yaw, -20 - _total_yaw, 20 - _total_yaw)
	_total_yaw += yaw
	
	# Prevents looking up/down too far
	pitch = clamp(pitch, -20 - _total_pitch, 20 - _total_pitch)
	_total_pitch += pitch

	standardCam.rotate_y(deg_to_rad(-yaw))
	standardCam.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

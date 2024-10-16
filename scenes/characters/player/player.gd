extends CharacterBody3D

@onready var area:Area3D = $Area3D
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var steps:Node = $Footsteps

@onready var standardCam:Camera3D = $Camera3D
@onready var chaseCam:Camera3D = $ChaseCamera

const door_type = preload("res://scenes/objects/doors/door_standard.gd")
const clue_type = preload("res://scenes/objects/clues/clue.gd")
const player_turn_type = preload("res://levels/turn.gd")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var footstep_timer = 0.5

func _ready():
	Globals.connect("pick_up_clue", pick_up_clue)
	#anim.play("rotate_sound_test")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle doors and picking up clues, etc
	if Input.is_action_just_pressed("interact") and is_on_floor():
		interact()
		
	if Input.is_action_just_pressed("chase_cam"):
		if chaseCam.current:
			Globals.load_level.emit("test-level", 0, "standard_cam")
		else:
			Globals.load_level.emit("test-chase-level", 0, "chase_cam")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and chaseCam.current:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir
	
	if standardCam.current:
		input_dir = Input.get_axis("move_left", "move_right")
	else:
		input_dir = Input.get_axis("move_down", "move_up")
	
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
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
			Globals.play_sound_2d.emit("door_open")
			Globals.load_level.emit(parent_node.to_level, a.global_position.x)
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

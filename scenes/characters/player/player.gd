extends CharacterBody3D

@onready var area:Area3D = $Area3D
@onready var anim:AnimationPlayer = $AnimationPlayer

const door_type = preload("res://scenes/objects/doors/door_standard.gd")
const clue_type = preload("res://scenes/objects/clues/clue.gd")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Globals.connect("pick_up_clue", pick_up_clue)
	#anim.play("rotate_sound_test")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle doors.
	if Input.is_action_just_pressed("interact") and is_on_floor():
		interact()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis("move_left", "move_right")
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func interact():
	for a in area.get_overlapping_areas():
		var parent_node = a.get_parent()
		
		if parent_node is Door:
			Globals.load_level.emit(parent_node.to_level, a.global_position.x)
			print("Door")
		if parent_node is Clue:
			Globals.pick_up_clue.emit(parent_node)
			print("Clue")

func pick_up_clue(clue):
	Globals.add_clue.emit(clue)
	clue.queue_free()

extends Node3D

var intro_done:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("intro_pan_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	if intro_done:
		if Input.is_action_just_pressed("interact"):
			Globals.load_level.emit("foyer", "standard_cam", "FrontDoorFoyer")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Intro finished")
	intro_done = true

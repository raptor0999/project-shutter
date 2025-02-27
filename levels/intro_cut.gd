extends Node3D

@onready var skip_label:Label = $Control/Skip

var intro_done:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("intro_pan_in")
	$Player/Body/Mesh/AnimationPlayer.play("idle")
	DialogueManager.connect("dialogue_ended", intro_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event) -> void:
	if Input.is_action_just_pressed("interact"):
		if intro_done:
			pass
			#Globals.load_level.emit("foyer", "standard_cam", "FrontDoorFoyer")
			#Globals.game_started = true
		else:
			if not skip_label.visible:
				skip_label.show()
				get_tree().create_timer(2.0).timeout.connect(func(): skip_label.hide())
			else:
				skip_label.hide()
				$AnimationPlayer.advance($AnimationPlayer.current_animation_length)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Intro finished")
	begin_intro_dialogue()
	intro_done = true

func begin_intro_dialogue():
	DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
	
func intro_end(resource):
	Globals.play_sound_2d.emit("door_open")
	Globals.load_level.emit("foyer", "standard_cam", "FrontDoorFoyer")
	Globals.game_started = true

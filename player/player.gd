extends CharacterBody2D

const speed = 100.0 

var input_vector = Vector2.ZERO
var _last_input

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	if state == "MoveState":
		input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if input_vector != Vector2.ZERO:
			last_input_vector = input_vector
			var direction_vector = Vector2(input_vector.x, -input_vector.y)
			update_blend_posistions(direction_vector)
			
		if Input.is_action_just_pressed("attack"):
			playback.travel("AttackState")
			
		velocity = input_vector * speed
		move_and_slide()

		
func update_blend_posistions(direction_vector: Vector2) -> void:
		animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
		animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)

extends CharacterBody2D

const speed = 100.0 

var input_vector = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = input_vector * speed
	move_and_slide()
	
	

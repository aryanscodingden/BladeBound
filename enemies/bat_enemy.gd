extends CharacterBody2D
const speed = 30

@export var RangePlayer:= 104

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@export var player: Player
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"Idle": pass
		"Chase": 
			player = get_player()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * speed
				sprite_2d.scale.x = sign(velocity.x)
			else:
				velocity = Vector2.ZERO
			move_and_slide()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var result = false 
	player = get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < RangePlayer: 
			result = true
	return result 

func can_see_player() -> bool:
	if not is_player_in_range(): return false
	player = get_player()
	ray_cast_2d.target_position = player.global_position - global_position
	print("raycast")
	ray_cast_2d.force_raycast_update()
	var has_los_to_player: = not ray_cast_2d.is_colliding()
	return has_los_to_player

	

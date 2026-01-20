extends CharacterBody2D

@export var player: Player
@export var RangePlayer:= 104

@export var range: = 128
@export var stats: stats

const speed = 30
const friction = 500 

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	stats.no_health.connect(queue_free)

func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState": 
			player = get_player()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * speed
			else:
				velocity = Vector2.ZERO
				#sprite_2d.scale.x = sign(velocity.x)
			move_and_slide()
		"HitState":
			velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
			move_and_slide()
			
func _on_area_entered(area_2D: Area2D) -> void:
	if area_2D is not Hitbox: return
	take_hit.call_deferred(area_2D)

func take_hit(other_hitbox: Hitbox) -> void:
	stats.health -= other_hitbox.damage
	velocity = other_hitbox.knockback_direction * other_hitbox.knoback_amount
	playback.start("HitState")
	print("Set the knockback to 200")
	
	
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
	var player: = get_player()
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	var has_los_to_player: = not ray_cast_2d.is_colliding()
	return has_los_to_player
	
	
	
	

	

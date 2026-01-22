extends CharacterBody2D
@export var RangePlayer:= 104
@export var attack_range: float = 5.0
@export var attack_cooldown: float = 1.0
@export var attack_damage: int = 1
@export var stats: Stats
const speed = 30
const friction = 500
var attack_timer: float = 0.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@export var player: Player
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	stats = stats.duplicate()
	area_2d.area_entered.connect(take_hit)
	if stats:
		stats.no_health.connect(queue_free)
	
func _physics_process(_delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= _delta
		
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState": 
			player = get_player()
			if player is Player:
				var distance_to_player = global_position.distance_to(player.global_position)
				if distance_to_player > attack_range:
					velocity = global_position.direction_to(player.global_position) * speed
					if velocity.x != 0:
						sprite_2d.scale.x = sign(velocity.x)
				else:
					velocity = Vector2.ZERO
					if attack_timer <= 0:
						attack_player()
						attack_timer = attack_cooldown
			else:
				velocity = Vector2.ZERO
			move_and_slide()
		"HitState":
			velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
			move_and_slide()
			
func take_hit(other_hitbox: Hitbox) -> void:
	if stats:
		stats.health -= other_hitbox.damage
	velocity = other_hitbox.knockback_direction * other_hitbox.knockback_amount 
	playback.start("HitState")
	print("Hit! Health remaining: ", stats.health if stats else "no stats")

func attack_player() -> void:
	player = get_player()
	if player and player.stats:
		player.stats.health -= attack_damage
		player.blink_animation_player.play("blink")
	print("Bat attacking player!")
	
	
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
	
	
	
	

	

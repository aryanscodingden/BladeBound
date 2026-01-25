extends CharacterBody2D
@export var RangePlayer:= 104
@export var attack_range: float = 20.0
@export var attack_cooldown: float = 2.0
@export var attack_damage: int = 1
@export var stats: Stats

const speed = 30
const friction = 200
const hit_effect = preload("uid://c56ny150wvyyv")
const death_effect = preload("uid://d3f47raaukmes")
var attack_timer: float = 0.0
var hit_state_timer: float = 0.0
const hit_state_duration: float = 0.4
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@export var player: Player
@onready var hurtbox: Hurtbox = $Area2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var navigation_agent_2d: NavigationAgent2D = $Marker2D/NavigationAgent2D
@onready var center: Marker2D = $Center


func _ready() -> void:
	stats = stats.duplicate()
	hurtbox.hurt.connect(take_hit)
	if stats:
		stats.no_health.connect(die)

func _physics_process(_delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= _delta
	
	if hit_state_timer > 0:
		hit_state_timer -= _delta
		
	var state = playback.get_current_node()
	match state:
		"IdleState": 
			if can_see_player():
				playback.travel("ChaseState")
		"ChaseState": 
			player = get_player()
			if player is Player:
				navigation_agent_2d.target_position = player.global_position
				var next_point = navigation_agent_2d.get_next_path_position() - marker_2d.position
				var distance_to_player = global_position.distance_to(player.global_position)
				if distance_to_player > attack_range:
					velocity = global_position.direction_to(next_point) * speed
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
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, friction * _delta)
			velocity = knockback_velocity
			move_and_slide()
			if hit_state_timer <= 0:
				collision_layer = 4
				collision_mask = 7
				playback.travel("IdleState")
func die() -> void:
	var death_effect_instance = death_effect.instantiate()
	get_tree().current_scene.add_child(death_effect_instance)
	death_effect_instance.global_position = global_position
	queue_free()
	pass
func take_hit(other_hitbox: Hitbox) -> void:
	var hit_effect_instance = hit_effect.instantiate()
	get_tree().current_scene.add_child(hit_effect_instance)
	hit_effect_instance.global_position = center.global_position
	if stats:
		stats.health -= other_hitbox.damage
	
	# Calculate knockback direction from hitbox position to enemy
	var knockback_dir = (global_position - other_hitbox.global_position).normalized()
	
	# Apply knockback
	collision_layer = 0
	collision_mask = 3
	knockback_velocity = knockback_dir * other_hitbox.knockback_amount
	velocity = knockback_velocity
	hit_state_timer = hit_state_duration
	playback.start("HitState")

func attack_player() -> void:
	player = get_player()
	if player and player.stats:
		player.stats.health -= attack_damage
		player.blink_animation_player.play("blink")
	
	
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
	
	
	
	

	

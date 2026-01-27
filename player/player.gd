class_name Player extends CharacterBody2D

const speed = 100.0 
const ROLL_SPEED = 125.0
const attack_duration = 0.25

var input_vector = Vector2.ZERO
var last_input_vector = Vector2.ZERO
var attack_timer := 0.0
var is_attacking = false

var max_health: int = 3
var current_health: int = 3

@export var stats: Stats
@onready var hurt_audio_stream_player: AudioStreamPlayer = $HurtAudioStreamPlayer
@onready var sword_hitbox: Hitbox = $SwordHitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback

func _ready() -> void:
	add_to_group("player")
	update_max_health()
	current_health = max_health
	if stats:
		stats.max_health = max_health
		stats.health = current_health
	UpgradeManager.stats_changed.connect(_on_stats_changed)
	hurtbox.hurt.connect(take_hit.call_deferred)
	if stats:
		stats.no_health.connect(die)
func update_max_health():
	var bonus_hp = UpgradeManager.get_bonus_health()
	max_health = 3 + bonus_hp 
	print("Max health updated to: %d (Base: 3 + Bonus: %d)" % [max_health, bonus_hp])

func _on_stats_changed():
	var old_max = max_health
	update_max_health()
	
	if max_health > old_max:
		var health_gained = max_health - old_max
		current_health += health_gained
		current_health = min(current_health, max_health)
		
		if stats:
			stats.max_health = max_health
			stats.health = current_health
		
		print("Gained %d max HP! Current: %d/%d" % [health_gained, current_health, max_health])

func die() -> void:
	hide()
	remove_from_group("player")
	process_mode = Node.PROCESS_MODE_DISABLED

func take_hit(other_hitbox: Hitbox) -> void:
	hurt_audio_stream_player.play()
	var reduction = UpgradeManager.get_damage_reduction()
	var actual_damage = max(1, other_hitbox.damage - reduction)
	stats.health -= actual_damage
	current_health = stats.health
	print("Player took %d damage (reduced from %d). Health: %d/%d" % [actual_damage, other_hitbox.damage, current_health, max_health])
	blink_animation_player.play("blink")

func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"MoveState":
			input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			if input_vector != Vector2.ZERO:
				sword_hitbox.knockback_direction = input_vector.normalized()
				last_input_vector = input_vector
				var direction_vector: = Vector2(input_vector.x, -input_vector.y)
				update_blend_positions(direction_vector)
			if is_attacking:
				attack_timer -= _delta
				velocity = Vector2.ZERO
				
			if attack_timer	<= 0.0:
				is_attacking = false
				playback.travel("MoveState") 
			if Input.is_action_just_pressed("attack"):
				is_attacking = true	
				var attack_speed_mult = UpgradeManager.get_attack_speed_multiplier()
				attack_timer = attack_duration / attack_speed_mult
				sword_hitbox.clear_hit_targets()
				var direction_vector: = Vector2(last_input_vector.x, -last_input_vector.y)
				update_blend_positions(direction_vector)
				playback.travel("AttackState")
				return
			if Input.is_action_just_pressed("roll"):
				playback.travel("RollState")
				return
			
			var speed_mult = UpgradeManager.get_speed_multiplier()
			velocity = input_vector * speed * speed_mult
			move_and_slide()
		"AttackState":
			velocity = Vector2.ZERO
			attack_timer -= _delta
			
			if attack_timer <= 0.0:
				playback.travel("MoveState")
		"RollState":
			velocity = last_input_vector.normalized() * ROLL_SPEED
			move_and_slide()
			pass
func _on_sword_hit_something(area: Area2D):
	print("the sword touched something")
	
	var parent = area.get_parent()
	if parent and parent.is_in_group("cuttable_grass") and parent.has_method("cut_grass"):
		print("oh its grass, cutting")
		parent.cut_grass()
		
func update_blend_positions(direction_vector: Vector2) -> void:
		animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
		animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
		animation_tree.set("parameters/StateMachine/AttackState/blend_position", direction_vector)
		animation_tree.set("parameters/StateMachine/RollState/blend_position", direction_vector)

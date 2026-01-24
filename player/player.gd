class_name Player extends CharacterBody2D

const speed = 100.0 
const ROLL_SPEED = 125.0
const attack_duration = 0.25

var input_vector = Vector2.ZERO
var last_input_vector = Vector2.ZERO
var attack_timer := 0.0
var is_attacking = false
@export var stats: Stats
@onready var hurt_audio_stream_player: AudioStreamPlayer = $HurtAudioStreamPlayer
@onready var sword_hitbox: Hitbox = $SwordHitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
func _ready() -> void:
	hurtbox.hurt.connect(take_hit.call_deferred)
	stats.no_health.connect(queue_free)
	if stats: 
		stats.no_health.connect(die)
	
func die() -> void:
	hide()
	remove_from_group("player")
	process_mode = Node.PROCESS_MODE_DISABLED

func take_hit(other_hitbox: Hitbox) -> void:
	hurt_audio_stream_player.play()
	stats.health -= other_hitbox.damage
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
				attack_timer = attack_duration
				sword_hitbox.clear_hit_targets()
				var direction_vector: = Vector2(last_input_vector.x, -last_input_vector.y)
				update_blend_positions(direction_vector)
				playback.travel("AttackState")
				return
			if Input.is_action_just_pressed("roll"):
				playback.travel("RollState")
				return
			
			velocity = input_vector * speed
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

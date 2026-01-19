extends Node2D
@onready var hurtbox: Hurtbox = $Hurtbox
@export var grass_effect: PackedScene

func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)

func _on_hurt(other_hitbox: Hitbox) -> void:
	if not other_hitbox.is_in_group("Sword"):
		return
	var grass_effect_instance = grass_effect.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	queue_free()
	

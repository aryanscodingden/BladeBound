class_name Hitbox extends Area2D

@export var damage: = 1
@export var knockback_amount: = 150
@export var knockback_direction: Vector2
@export var stores_hit_targets: bool = false

var hit_targets: Array

func _init() -> void:
	area_entered.connect(_on_area_entered)

func clear_hit_targets() -> void:
	hit_targets.clear()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		if area.has_method("take_hit"):
			area.take_hit(self)
	
	var parent = area.get_parent()
	if parent and parent.is_in_group("cuttable_grass"):
		if parent.has_method("cut_grass"):
			print("Hitbox detected grass")
			parent.cut_grass()
	
	

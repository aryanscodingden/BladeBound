extends Node2D
@onready var area_2d: Area2D = $Area2D
@export var grass_effect: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	
func _on_area_2d_area_entered(other_area_2d: Area2D) -> void:
	if not other_area_2d.is_in_group("Sword"):
		return
	
	var grass_effect_instance = grass_effect.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	if other_area_2d.is_in_group("Sword"):
		queue_free()
		


	print("Grass area entered")
	

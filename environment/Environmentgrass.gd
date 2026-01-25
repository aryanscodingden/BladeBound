extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

var is_cut: bool = false

const coin_scene = preload("uid://c6yxctc7uh8ne")

func _ready() -> void:
	add_to_group("cuttable_grass")

func cut_grass():
	if is_cut:
		return 
	is_cut = true
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.3)

	var coin_amount = randi_range(1, 3)
	spawn_coins(coin_amount)
	GameManager.grass_cut += 1 
	await tween.finished
	queue_free()

func spawn_coins(amount: int):
	for i in amount: 
		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		
		var offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		coin.global_position = global_position + offset
		await get_tree().create_timer(0.05).timeout

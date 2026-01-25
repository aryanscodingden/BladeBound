extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var is_cut: bool = false

# Preload the coin scene (correct UID for effects/coin.tscn)
const COIN_SCENE = preload("uid://c6yxctc7uh8ne")

func _ready():
	add_to_group("cuttable_grass")

func cut_grass():
	if is_cut:
		return
	is_cut = true
	print("Grass was cut")
	
	var spawn_position = global_position
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.3)
	var coin_amount = randi_range(1, 3)
	spawn_coins(coin_amount, spawn_position)
	GameManager.grass_cut += 1
   
	await tween.finished
	queue_free()

func spawn_coins(amount: int, spawn_pos: Vector2):
	for i in amount:
		var coin = COIN_SCENE.instantiate()
		if coin == null:
			print("❌ ERROR: Could not create coin!")
			return
		var world = get_parent()
		if world:
			world.add_child(coin)
			var offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
			coin.global_position = spawn_pos + offset
			print("Coin spawned at: %s" % coin.global_position)
		else:
			print("ERROR: Could not find world!")

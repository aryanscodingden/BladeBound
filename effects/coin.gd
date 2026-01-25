extends Area2D

@export var coin_value: int = 1
@export var collection_range: float = 20.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_collected: bool = false

func _ready():
	add_to_group("collectible")
	body_entered.connect(_on_body_entered)
	if animated_sprite:
		animated_sprite.play("default")
	spawn_animation()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		GameManager.coins += 1 
		queue_free()
	
func spawn_animation():
	scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)

func _process(_delta):
	if is_collected:
		return 
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return 
	var player = players[0]
	var distance = global_position.distance_to(player.global_position)
	
	if distance < collection_range:
		is_collected = true 
		collect()
		
func collect():
	print("coins collected")
	GameManager.add_coins(coin_value)
	
	var collect_tween = create_tween()
	collect_tween.set_parallel(true)
	collect_tween.tween_property(self, "global_position:y", global_position.y - 30, 0.3)
	collect_tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	await collect_tween.finished
	queue_free()

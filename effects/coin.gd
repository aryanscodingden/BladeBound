extends Area2D

@export var coin_value: int = 1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_collected: bool = false

func _ready():
	add_to_group("collectible")
	
	body_entered.connect(_on_body_collect)
	
	if animated_sprite:
		animated_sprite.play("default")
	spawn_animation()
	
func spawn_animation():
	scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)

func _on_body_collect(body: Node2D):
	if is_collected:
		return 
	if body.is_in_group("player"):
		is_collected = true
		collect()
		
func collect():
	print("Coin collected")
	GameManager.add_coins(coin_value)
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tweeen_property(self, "global_position:y", global_position.y - 30, 0.6)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	
	await tween.finished
	queue_free()

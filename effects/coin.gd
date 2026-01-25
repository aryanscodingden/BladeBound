extends Area2D

@export var coin_value: int = 1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_collected: bool = false

func _ready():
	add_to_group("collectible")

extends Node

signal coins_changed(new_amount)

var coins: int = 0:
	set(value):
		coins = value
		coins_changed.emit(coins)
		print("Coins now: %d" % coins)

var kills: int = 0
var grass_cut: int = 0

func _ready():
	print("GameManager ready!")

extends Node

var coins: int = 0 
var kills: int = 0 
var grass_cut: int = 0

signal coins_changed(amount)

func add_coins(amount: int):
	coins += amount
	coins_changed.emit(coins)
	print("You've got coins, Total:", [amount, coins])
	
func reset_game():
	coins = 0 
	kills = 0 
	grass_cut = 0
	

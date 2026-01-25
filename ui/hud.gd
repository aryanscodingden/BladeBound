extends CanvasLayer
@onready var coin_amount_label: Label = $CoinDisplay/CoinAmountLabel

func _ready() -> void:
	GameManager.coins_changed.connect(update_coin_display)
	update_coin_display(GameManager.coins)
	print("Coin display ready!")
	if coin_amount_label:
		GameManager.coins_changed.connect(update_coin_display)
		update_coin_display(GameManager.coins)
		print("Coin display ready")
	else:
		print("Cant find CoinAmountLabel")
		
	
func update_coin_display(amount:int):
	if coin_amount_label:
		coin_amount_label.text = str(amount)
		print("Coin amount displayed")
		

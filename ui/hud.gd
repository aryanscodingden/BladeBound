extends CanvasLayer
@onready var coin_amount_label: Label = $CoinDisplay/CoinAmountLabel

func _ready() -> void:
	setup_coin_display()
func setup_coin_display():
	if has_node("CoinDisplay/CoinAmountLabel"):
		coin_amount_label = get_node("CoinDisplay/CoinAmountLabel")
	elif has_node("CoinAmountLabel"):
		coin_amount_label = get_node("CoinAmountLabel")
	else:
		for child in get_children():
			return 
			
	if GameManager.coins_changed.is_connected(update_coin_display):
		print("Already connected to coins_changed")
	else:
		GameManager.coins_changed.connect(update_coin_display)
		
	update_coin_display(GameManager.coins)
	print("Coin display ready!")

func update_coin_display(amount: int):
	if coin_amount_label:
		coin_amount_label.text = str(amount)

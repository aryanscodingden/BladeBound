extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect
@onready var text_edit: TextEdit = $TextEdit
@onready var buy_button_1: Button = $BuyButton1
@onready var buy_button_2: Button = $BuyButton2
@onready var buy_button_3: Button = $BuyButton3
@onready var buy_button_4: Button = $BuyButton4
@onready var buy_button_5: Button = $BuyButton5
@onready var extra_heart: Label = $ShopLabel/ExtraHeart
@onready var sharp_blade: Label = $ShopLabel/SharpBlade
@onready var speed_blade: Label = $ShopLabel/SpeedBlade
@onready var quick_slash: Label = $ShopLabel/QuickSlash
@onready var sheild: Label = $ShopLabel/Sheild
@onready var coin: TextureRect = $Coin
@onready var coin_2: TextureRect = $Coin2
@onready var coin_3: TextureRect = $Coin3
@onready var coin_4: TextureRect = $Coin4
@onready var coin_5: TextureRect = $Coin5


var is_open: bool = false

func _ready() -> void:
	visible = false
	is_open = false
	
	buy_button_1.pressed.connect(func(): buy_upgrade("extra_hearts"))
	buy_button_2.pressed.connect(func(): buy_upgrade("sharp_blade"))
	buy_button_3.pressed.connect(func(): buy_upgrade("speed_boost"))
	buy_button_4.pressed.connect(func(): buy_upgrade("quick_slash"))
	buy_button_5.pressed.connect(func(): buy_upgrade("shield"))
	
	GameManager.coins_changed.connect(_on_coins_changed)
	print("Shop UI ready!")

func _input(event):
	if event.is_action_pressed("shop"):
		if is_open:
			close_shop()
		else:
			open_shop()

func open_shop():
	visible = true
	is_open = true
	get_tree().paused = true
	update_prices()
	update_button_states()
	print("Shop opened!")

func close_shop():
	visible = false
	is_open = false
	get_tree().paused = false
	print("Shop closed!")

func buy_upgrade(upgrade_id: String):  
	var success = UpgradeManager.buy_upgrade(upgrade_id)

	if success:
		update_prices()
		update_button_states()
		show_notification(upgrade_id)
		print("Bought: " + upgrade_id)
	else: 
		print("Failed to buy: " + upgrade_id)

func update_prices():
 	coin.text = str(UpgradeManager.upgrades["extra_hearts"]["cost"])
	coin_2.text = str(UpgradeManager.upgrades["sharp_blade"]["cost"])
	coin_3.text = str(UpgradeManager.upgrades["speed_boost"]["cost"])
	coin_4.text = str(UpgradeManager.upgrades["quick_slash"]["cost"])
	coin_5.text = str(UpgradeManager.upgrades["shield"]["cost"])

func update_button_states():
	update_single_button(buy_button_1, "extra_hearts")
	update_single_button(buy_button_2, "sharp_blade")
	update_single_button(buy_button_3, "speed_boost")
	update_single_button(buy_button_4, "quick_slash")
	update_single_button(buy_button_5, "shield")

func update_single_button(button: Button, upgrade_id: String):
	var upgrade = UpgradeManager.upgrades[upgrade_id]
	var is_maxed = upgrade["count"] >= upgrade["max_count"]  
	var can_afford = GameManager.coins >= upgrade["cost"]  
	
	if is_maxed:
		button.disabled = true
		button.text = "MAX"
		button.modulate = Color(0.5, 0.8, 0.5, 1)
	elif not can_afford:
		button.disabled = true
		button.modulate = Color(0.6, 0.6, 0.6, 1)
		button.text = "BUY"
	else: 
		button.disabled = false
		button.text = "BUY"
		button.modulate = Color(1, 1, 1, 1) 

func _on_coins_changed(_amount: int): 
	if is_open:
		update_button_states()

func show_notification(upgrade_id: String):  
	var upgrade = UpgradeManager.upgrades[upgrade_id]
	var upgrade_name = upgrade["name"]
	var icon = upgrade["icon"]
	var level = upgrade["count"]
	
	print("⚡ %s %s Lv.%d ACTIVE!" % [icon, upgrade_name, level])

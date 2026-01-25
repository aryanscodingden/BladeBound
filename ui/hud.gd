extends CanvasLayer
@onready var coin_amount_label: Label = $CoinDisplay/CoinAmountLabel
var coin_amount_label: Label = null
var wave_timer_label: Label = null

func _ready() -> void:
	setup_coin_display()
	setup_wave_timer()
func setup_wave_timer():
	if has_node("WaveTimerLabel"):
		wave_timer_label = get_node("WaveTimerLabel")
	else:
		wave_timer_label = Label.new()
		wave_timer_label.name = "WaveTimerLabel"
		add_child(wave_timer_label)
	
	wave_timer_label.position = Vector2(20,80)
	wave_timer_label.add_theme_font_size_override("font_size", 22)
	wave_timer_label.add_theme_color_override("font_color", Color(1,1,0))
func update_wave_timer(seconds: int):
	if wave_timer_label:
		wave_timer_label.text = "Wave %d" % wave_num
		
		var tween = create_tween()
		tween.tween_property(wave_timer_label, "scale", Vector2(1.3, 1.3), 0.2)
		tween.tween_property(wave_timer_label, "scale", Vector2(1.0, 1.0), 0.2s)
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

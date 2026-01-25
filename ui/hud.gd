extends CanvasLayer

@onready var coin_amount_label: Label = $CoinDisplay/CoinAmountLabel
@onready var wave_timer_label: Label = $WaveTimePanel/WaveTimerLabel

func _ready() -> void:
	GameManager.coins_changed.connect(update_coin_display)
	update_coin_display(GameManager.coins)
	
	WaveManager.wave_countdown.connect(update_wave_timer)
	WaveManager.wave_started.connect(on_wave_started)
	print("HUD ready!")
	
func update_coin_display(amount: int):
	if coin_amount_label:
		coin_amount_label.text = str(amount)

func update_wave_timer(seconds: int):
	if wave_timer_label:
		wave_timer_label.text = "Next Wave: %ds" % seconds

func on_wave_started(wave_num: int):
	if wave_timer_label:
		wave_timer_label.text = "WAVE %d" % wave_num
		
		await get_tree().create_timer(2.0).timeout
		

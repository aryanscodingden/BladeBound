extends CanvasLayer

@onready var background: TextureRect = $Background
@onready var main_panel: PanelContainer = $MainPanel
@onready var coins_panel: Label = $MainPanel/MainContainer/TopInfo/CoinsLabel
@onready var stats_label: Label = $MainPanel/MainContainer/TopInfo/StatsLabel
@onready var upgrade_list: VBoxContainer = $MainPanel/MainContainer/UpgradeScroll/UpgradeList
@onready var close_button: Button = $MainPanel/MainContainer/ButtonRow/CloseButton

var is_open: bool = false

func _ready():
	visible = false
	is_open = false
	close_button.pressed.connect(close_shop)
	GameManager.coins_changed.connect(update_coins_display)
	UpgradeManager.stats_changed.connect(update_stats_display)
	
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
	update_coins_display(GameManager.coins)
	update_stats_display()
	refresh_upgrade_list()
	
func close_shop():
	visible = false
	is_open = false
	get_tree().paused = false

func update_coins_display(amount: int):
	if coins_label:
		coins_label.text = "Coins: %d" % amount

func update_stats_display(amount: int):
	if stats_label:
		var dmg = UpgradeManager.get_total_damage()
		var spd = int(UpgradeManager.get_speed_multiplier() * 100)
		var def_val = UpgradeManager.get_damage_reduction()
		var hp = UpgradeManager.get_bonus_health()
		stats_label.text = "DMG:%d SPD:%d%% DEF:%d +HP:%d" % [dmg, spd, def_val, hp]
func refresh_upgrade_list():
	for child in upgrade_list.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	

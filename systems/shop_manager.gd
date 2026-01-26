extends Node

signal weapon_changed(weapon_name, damage)
signal purchase_made(weapon_name)

var upgrades = {
	"extra_hearts": {
		"name": "Extra Heart",
		"icon": "❤️",
		"description": "+1 max health",
		"cost": 35,
		"owned": false,
		"max_count": 5,
		"count": 0
	},
	"sharp_blade": {
		"name": "Sharp Blade",
		"icon": "⚔️",
		"description": "+1 sword hit",
		"cost": 45,
		"owned": false,
		"max_count": 5,
		"count": 0
	},
	"speed_boost": {
		"name": "Speed Boost",
		"icon": "🏃",
		"description": "Move 20% faster",
		"cost": 20,
		"owned": false,
		"max_count": 3,
		"count": 0
	},
	"quick_slash": {
		"name": "Quick slash",
		"icon": "💨",
		"description": "Attack 25% faster",
		"cost": 35,
		"owned": false,
		"max_count": 2,
		"count": 0
	},
	"Shield": {
		"name": "Shield",
		"icon": "🛡️",
		"description": "Take 1 less damage",
		"cost": 50, 
		"max_count": 2,
		"count": 0
	},
}

var bounus_health: int = 0
var bonus_damage: int = 0
var bonus_speed: float = 0
var bonus_attack_stream: float = 0.0
var damage_protection: int = 0

func _ready() -> void:
	print("Shop manager ready")

func _buy_upgrade(upgrade_id: String) -> bool: 
	if not upgrades.has(upgrade_id):
		print("upgrade not found" + upgrade_id)
		return false
	
	var upgrade = upgrades[upgrade_id]
	
	if upgrade["count"] >= upgrade["max_count"]:
		return false
	
	if GameManager.coins < upgrade["cost"]:
		return false
	
	GameManager.coins -= upgrade["cost"]
	upgrade["count"] += 1
	upgrade["owned"] = true
	
	upgrade["cost"] = int(upgrade["cost"] * 1.5)
	
	apply_upgrade(upgrade_id)
	upgrade_purchased.emit(upgrade["name"])
	stats_change.emit()

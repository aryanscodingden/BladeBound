extends Node

signal upgrade_purchased(upgrade_name)
signal stats_changed()

var upgrades = {
	"extra_hearts": {
		"name": "Extra Heart",
		"icon": "❤️",
		"description": "+1 max health",
		"cost": 20,
		"max_count": 5,
		"count": 0
	},
	"sharp_blade": {
		"name": "Sharp Blade",
		"icon": "⚔️",
		"description": "+1 sword damage",
		"cost": 30,
		"max_count": 5,
		"count": 0
	},
	"speed_boost": {
		"name": "Speed Boost",
		"icon": "🏃",
		"description": "Move 20% faster",
		"cost": 35,
		"max_count": 3,
		"count": 0
	},
	"quick_slash": {
		"name": "Quick Slash",
		"icon": "💨",
		"description": "Attack 25% faster",
		"cost": 40,
		"max_count": 3,
		"count": 0
	},
	"shield": {
		"name": "Shield",
		"icon": "🛡️",
		"description": "Take 1 less damage",
		"cost": 40,
		"max_count": 3,
		"count": 0
	}
}

var bonus_health: int = 0
var bonus_damage: int = 0
var bonus_speed: float = 0.0
var bonus_attack_speed: float = 0.0
var damage_reduction: int = 0

func _ready():
	print("UpgradeManager")

func buy_upgrade(upgrade_id: String) -> bool:
	if not upgrades.has(upgrade_id):
		print("Upgrade not found: " + upgrade_id)
		return false
	
	var upgrade = upgrades[upgrade_id]
	
	if upgrade["count"] >= upgrade["max_count"]:
		print("Already maxed: " + upgrade["name"])
		return false
	
	if GameManager.coins < upgrade["cost"]:
		print("Not enough coins!")
		return false
	
	GameManager.coins -= upgrade["cost"]
	upgrade["count"] += 1
	upgrade["cost"] = int(upgrade["cost"] * 1.5)
  
	match upgrade_id:
		"extra_hearts":
			bonus_health += 1
			print("+1 Max HP! Total bonus: %d" % bonus_health)
		"sharp_blade":
			bonus_damage += 1
			print("+1 Damage! Total: %d" % (1 + bonus_damage))
		"speed_boost":
			bonus_speed += 0.2
			print("+20%% Speed! Multiplier: %.2f" % (1.0 + bonus_speed))
		"quick_slash":
			bonus_attack_speed += 0.25
			print("+25%% Attack Speed! Multiplier: %.2f" % (1.0 + bonus_attack_speed))
		"shield":
			damage_reduction += 1
			print("+1 Shield! Damage reduction: %d" % damage_reduction)
	
	print("Bought: %s (Level %d)" % [upgrade["name"], upgrade["count"]])
	upgrade_purchased.emit(upgrade["name"])
	stats_changed.emit()
	
	return true

func get_bonus_health() -> int:
	return bonus_health

func get_total_damage() -> int:
	return 1 + bonus_damage

func get_speed_multiplier() -> float:
	return 1.0 + bonus_speed

func get_attack_speed_multiplier() -> float:
	return 1.0 + bonus_attack_speed

func get_damage_reduction() -> int:
	print("Getting damage reduction: %d" % damage_reduction)
	return damage_reduction

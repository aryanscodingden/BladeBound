extends Node

var current_wave: int = 0 
var time_until_next_wave: float = 30.0
var enemies_per_wave: int = 3
var wave_active: bool = false

signal wave_started(wave_number)
signal wave_countdown(seconds_left)
signal enemies_defeated()

func _ready():
	print("Wave manager initialized!")
	print("First wave in 30 seconds!")
func _process(delta: float) -> void:
	if wave_active:
		return 
	
	time_until_next_wave -= delta
	
	var seconds = int(time_until_next_wave)
	if seconds != int(time_until_next_wave + delta):
		wave_countdown.emit(seconds)
		print("next wave: in %d seconds", % seconds)
		
	if time_until_next_wave <= 0:
		start_wave()
func start_wave():
	current_wave += 1
	wave_active = true
	time_until_next_wave = 30.0
	
	print("Wave %d starting" % current_wave)
	wave_started.emit(current_wave)
	
	var enemy_count = enemies_per_wave + (current_wave - 1)
	print("%d enmies will spawn", % enemy_count)
	print("Enemies will spawn here when we do add the ode")
	await get_tree().create_timer(10.0).timeout
	all_enemies_defeated()
	
func all_enemies_defeated():
	if not wave_active:
		return

	wave_active = false
	print("Wave %d comeplete!" % current_wave)
	print("Next wave in 30 seconds...")
	
	enemies_defeated.emit()

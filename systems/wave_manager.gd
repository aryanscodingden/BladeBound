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
	
	print("=" * 40)
	print("Wave %d starting" % current_wave)
	print("=" * 40)
	
	wave_started.emit(current_wave)

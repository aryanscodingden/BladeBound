extends Node
const BAT_ENEMY = preload("res://enemies/bat_enemy.tscn")

var current_wave: int = 0 
var time_until_next_wave: float = 30.0
var enemies_per_wave: int = 3
var wave_active: bool = false
var active_enemies: Array = []
var last_emitted_second: int = -1

signal wave_started(wave_number)
signal wave_countdown(seconds_left)
signal enemies_defeated()

func _ready():
	print("Wave Manager initialized!")
	
func _process(delta: float) -> void:
	if wave_active:
		check_enemies()
		return 
	
	time_until_next_wave -= delta
	
	var current_second = int(time_until_next_wave)
	if current_second != last_emitted_second:
		last_emitted_second = current_second
		if current_second >= 0:
			wave_countdown.emit(current_second)
		
	if time_until_next_wave <= 0:
		start_wave()

func start_wave():
	current_wave += 1
	wave_active = true
	time_until_next_wave = 30.0
	print("WAVE %d STARTING!" % current_wave)
	wave_started.emit(current_wave)
	
	var enemy_count = enemies_per_wave + (current_wave - 1)
	spawn_enemies(enemy_count)

func spawn_enemies(count: int):
	active_enemies.clear()
	
	var world = get_tree().current_scene
	if not world:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
		
	var player_pos = player.global_position
	 
	for i in count:
		var enemy = BAT_ENEMY.instantiate()
		
		if not enemy:
			continue
		
		world.add_child(enemy)
		
		var angle = randf() * TAU
		var distance = randf_range(150, 300)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		
		enemy.global_position = player_pos + offset
		active_enemies.append(enemy)
		
		print("Enemy %d spawned at: %s" % [i + 1, enemy.global_position])
		await get_tree().create_timer(0.2).timeout
func check_enemies():
	active_enemies = active_enemies.filter(func(enemy): return is_instance_valid(enemy))
	
	if active_enemies.size() == 0:
		all_enemies_defeated()

func all_enemies_defeated():
	if not wave_active:
		return

	wave_active = false
	enemies_defeated.emit()

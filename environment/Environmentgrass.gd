extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

var is_cut: bool = false

func _ready():
	add_to_group("cuttable_grass")
func cut_grass():
	if is_cut:
		return
	is_cut = true
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	#random coins es
	var coin_amount = randi_range(1, 3)  
	GameManager.add_coins(coin_amount)
	GameManager.grass_cut += 1
	show_coin_popup(coin_amount)
	
	
	await tween.finished
	queue_free()

func show_coin_popup(amount: int):
	var label = Label.new()
	label.text = "+%d 💰" % amount
	label.add_theme_font_size_override("font_size", 24)
	
	get_tree().current_scene.add_child(label)
	label.global_position = global_position - Vector2(0, 20)
	

	var popup_tween = create_tween()  
	popup_tween.set_parallel(true) 
	popup_tween.tween_property(label, "global_position:y", global_position.y - 60, 1.0)  
	popup_tween.tween_property(label, "modulate:a", 0.0, 1.0)  
	
	await popup_tween.finished
	label.queue_free()

	

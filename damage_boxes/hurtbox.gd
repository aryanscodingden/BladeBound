class_name Hurtbox extends Area2D

signal hurt(hitbox: Hitbox)

func _ready() -> void:
	print("Hurtbox _ready called for: ", get_parent().name if get_parent() else "no parent")
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D) -> void:
	print("Hurtbox detected area: ", area_2d, " is Hitbox: ", area_2d is Hitbox)
	if area_2d is not Hitbox: return
	var hitbox = area_2d as Hitbox
	area_2d = area_2d as Hitbox 
	if self in area_2d.hit_targets: return 
	if hitbox.stores_hit_targets: hitbox.hit_targets.append(self)
	print("Emitting hurt signal from: ", get_parent().name)
	hurt.emit(area_2d)

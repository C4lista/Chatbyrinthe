extends CanvasLayer


func _ready():
	await get_tree().create_timer(1.0).timeout
	# 1 seconde avant le debut de l'animation
	$AnimationPlayer.play("Ecran Noir")

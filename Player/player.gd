extends Area2D

var taille_tuile = 48
# taille des tuiles

var vies = 3
# nombre de vies

func _ready(): # placement initial
	position = position.snapped(Vector2.ONE * taille_tuile)
	position += Vector2.ONE * taille_tuile/2
		# positionnement au centre de la case
	$AnimatedSprite2D.play("idle")

@onready var murs = $"/root/Labyrinthe/TileMapMur"
# importation de la couche qui contient les murs 

func mur(x, y):
	var cell: Vector2i = murs.local_to_map(Vector2(x, y))
	return murs.get_cell_source_id(cell) != -1
		# test qui renvoie TRUE si l'id du Tile Map est autre que -1
		# -1 = pas de murs = renvoie FALSE

@onready var fins = $"/root/Labyrinthe/TileMapFin"
# importation de la couche qui contient la tuile de sortie

func test_fin(x,y):
	var cell: Vector2i = fins.local_to_map(Vector2(x, y))
	if fins.get_cell_source_id(cell) == 0:
		set_process_unhandled_input(false)
			# bloque les touches du joueur
			# il ne peut plus bouger
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(1.0).timeout
		$victory.play()
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Menu/Menu.tscn")
			# si la tuile de sortie est touché, quitte le niveau
	

func vie():
	if vies == 3: # si encore on a encore des vies
		vies -= 1;
		$collide.play() # song
		$CanvasLayer/Health/life1.hide() 
			# cache une tete (vie)
		
	elif vies == 2:
		vies -= 1;
		$collide.play()
		$CanvasLayer/Health/life2.hide()
		
	else: # le compteur est a zero
		set_process_unhandled_input(false)
		$CanvasLayer/Health/life3.hide()
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(1.0).timeout
		$fail.play()
			# song de defaite
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Game/Mecanique/GameOver.tscn")
			# ecran de game over



func _unhandled_input(event): # mouvement
	# si _process(delta) = mouvement continus
	
	var test_mur_x
	var test_mur_y
	
	if event.is_action_pressed("right"):
		test_mur_x = position.x + taille_tuile
		test_mur_y = position.y
		$AnimatedSprite2D.play("walk_s")
		$AnimatedSprite2D.flip_h = true
			# retournement horizontale du sprite
			
		if not mur(test_mur_x, test_mur_y):
				# aller à droite
			position.x += taille_tuile
			$move.play()
			test_fin(position.x, position.y)
		else:
			vie()
			

	if Input.is_action_pressed("left"):
		test_mur_x = position.x - taille_tuile
		test_mur_y = position.y
		$AnimatedSprite2D.play("walk_s")
		$AnimatedSprite2D.flip_h = false
			# pas de retournement horizontale du sprite
			# car sprite dans le bon sens
			
		if not mur(test_mur_x, test_mur_y):
				# aller à gauche
			position.x -= taille_tuile
			$move.play()
			test_fin(position.x, position.y)
		else:
			vie()

	if Input.is_action_pressed("up"):
		test_mur_x = position.x
		test_mur_y = position.y - taille_tuile
		$AnimatedSprite2D.play("walk_b")
		
		if not mur(test_mur_x, test_mur_y):
			# aller en haut
			position.y -= taille_tuile
			$move.play()
			test_fin(position.x, position.y)
		else:
			vie()

	if Input.is_action_pressed("down"):
		test_mur_x = position.x
		test_mur_y = position.y + taille_tuile
		$AnimatedSprite2D.play("walk_f")
		
		if not mur(test_mur_x, test_mur_y):
			# aller en bas
			position.y += taille_tuile
			$move.play()
			test_fin(position.x, position.y)
		else:
			vie()

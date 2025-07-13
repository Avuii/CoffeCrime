extends CharacterBody2D
class_name Player  
@export var speed: float = 75.0
@onready var anim_sprite = $AnimatedSprite2D




func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

	# ANIMACJE
	if input_vector == Vector2.ZERO:
		anim_sprite.stop()
	else:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				anim_sprite.play("walk_right")
			else:
				anim_sprite.play("walk_left")
		else:
			if input_vector.y > 0:
				anim_sprite.play("walk_down")
			else:
				anim_sprite.play("walk_up")

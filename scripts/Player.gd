extends Area2D

const MOVE_SPEED = 150.0
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

var shot_scene = preload("res://scenes/Shot.tscn")
var explosion_scene = preload("res://scenes/Explosion.tscn")
var can_shoot = true

signal destroyed


func _process(delta):
	var input_dir = Vector2()

	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0

	position += (delta * MOVE_SPEED) * input_dir

	if position.x < 8.0:
		position.x = 8.0
	elif position.x > SCREEN_WIDTH - 8.0:
		position.x = SCREEN_WIDTH - 8.0

	if position.y < 8.0:
		position.y = 8.0
	elif position.y > SCREEN_HEIGHT -8.0 :
		position.y = SCREEN_HEIGHT -8.0

	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		can_shoot = false
		get_node("ReloadTimer").start()

		var stage_node = get_parent()

		var left_shot_instance = shot_scene.instance()
		left_shot_instance.position = position + Vector2(9, -5)

		var right_shot_instance = shot_scene.instance()
		right_shot_instance.position = position + Vector2(9, 5)

		stage_node.add_child(left_shot_instance)
		stage_node.add_child(right_shot_instance)


func _on_ReloadTimer_timeout():
	can_shoot = true


func _on_Player_area_entered(area):
	if area.is_in_group("asteroid"):
		emit_signal("destroyed")
		queue_free()

		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()

		explosion_instance.position = position
		stage_node.add_child(explosion_instance)



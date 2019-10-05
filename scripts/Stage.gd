extends Node2D

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

var asteroid_scene = preload("res://scenes/Asteroid.tscn")
var is_game_over = false
var score = 0


func _ready():
	get_node("SpawnTimer").connect("timeout", self, "_on_SpawnTimer_timeout")
	get_node("Player").connect("destroyed", self, "_on_Player_destroyed")


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://scenes/Stage.tscn")


func _on_SpawnTimer_timeout():
	var asteroid_instance = asteroid_scene.instance()
	asteroid_instance.position = Vector2(SCREEN_WIDTH + 8, rand_range(0, SCREEN_HEIGHT))
	asteroid_instance.connect("score", self, "_on_Player_score")
	add_child(asteroid_instance)


func _on_Player_score():
	score += 1
	get_node("UI/Score").text = "Score: " + str(score)


func _on_Player_destroyed():
	get_node("UI/Retry").show()
	is_game_over = true
extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D

func _process(delta):
	camera.position = player.position

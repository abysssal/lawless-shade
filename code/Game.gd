extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var itemLabel = $UI/GUI/Item
@onready var gui = $UI
	
func _process(delta):
	camera.position = player.position
	#gui.position = camera.position - Vector2(get_window().size / 2)

func when_item_changes(itemName): 
	itemLabel.text = "Selected Item: " + itemName

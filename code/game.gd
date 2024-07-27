extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var strengthBar = $UI/GUI/StrengthBar
@onready var scoreLabel = $UI/GUI/Score
@onready var gui = $UI
@onready var potionCreationPos = $Player/Node2D/looker
@onready var point1 = $Map/SpawnPoint1
@onready var point2 = $Map/SpawnPoint2
@onready var items = [$UI/GUI/Items/Item1, $UI/GUI/Items/Item2, $UI/GUI/Items/Item3]

@onready var walker = preload("res://scenes/walker.tscn")
@onready var potion = preload("res://scenes/potion.tscn")
@onready var gameOver = preload("res://scenes/gameOver.tscn")

var playerPosition
var score = 0
var enemyCount = 0
	
func _process(delta):
	var localEnemyCount = 0
	
	camera.position = player.position
	playerPosition = player.global_position
	scoreLabel.text = str(score)
	
	if player.throwStrength == 0:
		strengthBar.visible = false
	else:
		strengthBar.visible = true
		strengthBar.value = player.throwStrength * 100
	
	if enemyCount < 5:
		var localEnemy = walker.instantiate()
		localEnemy.global_position = Vector2(randi_range(point1.position.x, point2.position.x), randi_range(point1.position.y, point2.position.y))
		add_child(localEnemy)
		
	for node in get_children():
		if node.is_in_group("walker"):
			localEnemyCount += 1
			
	if not localEnemyCount == enemyCount:
		enemyCount = localEnemyCount
			
	for index in range(len(player.items)):
		print(player.items[index])
		items[index].modulate = getPotionSpriteColor(player.items[index])
						
		if player.items[index] == "none":
			items[index].texture = load("res://art/nothing.png")
		else:
			items[index].texture = load("res://art/potion.png")
		
	
func when_item_changes(itemName): 
	print(itemName) 
	
func _on_player_potion_toss(potionName, strength):
	match potionName:
		"Damage Potion":
			var localPotion = potion.instantiate()
			localPotion.global_position = potionCreationPos.global_position
			localPotion.strength = strength * 2
			localPotion.type = potionName
			add_child(localPotion)

func _on_player_die():
	get_tree().change_scene_to_packed(gameOver)

func getPotionSpriteColor(potion : String):
	var color : Color
	
	match potion:
		"none":
			color = Color(1, 1, 1)
		"Damage Potion":
			color = Color8(255, 170, 255)
			
	return color

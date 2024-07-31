extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var strengthBar = $UI/GUI/StrengthBar
@onready var scoreLabel = $UI/GUI/Score
@onready var gui = $UI
@onready var potionCreationPos = $Player/Node2D/looker
@onready var point1 = $Map/SpawnPoint1
@onready var point2 = $Map/SpawnPoint2
@onready var point3 = $Map/SpawnPoint3
@onready var point4 = $Map/SpawnPoint4
@onready var items = [$UI/GUI/Items/Item1, $UI/GUI/Items/Item2, $UI/GUI/Items/Item3]
@onready var itemLabels = [$UI/GUI/Items/Item1/Label, $UI/GUI/Items/Item2/Label, $UI/GUI/Items/Item3/Label]
@onready var doors : Array

@onready var walker = preload("res://scenes/walker.tscn")
@onready var juggernaut = preload("res://scenes/juggernaut.tscn")
@onready var para = preload("res://scenes/para.tscn")
@onready var potion = preload("res://scenes/potion.tscn")
@onready var potionPickUp = preload("res://scenes/potionPickUp.tscn")
@onready var gameOver = preload("res://scenes/gameOver.tscn")

var playerPosition
var score = 0

var enemyCount = 0
var maxEnemyCount = 5
var enemySpawnCooldown = 0

var potionCount = 0
var maxPotionCount = 10
var potionSpawnCooldown = 0

var timer = 0

var doorTimer = 0
var door = -1
var lastDoorPos
var currentDoorPos

func _ready():
	for node in $Map.get_children():
		if "Door" in node.name:
			doors.append(node)
			
	lastDoorPos = Vector2(850, 130)
	currentDoorPos = doors[0].global_position
			
	print(doors)
	
func _process(delta):
	timer += delta
	doorTimer += delta
	potionSpawnCooldown += delta
	enemySpawnCooldown += delta
	
	var localEnemyCount = 0
	var localPotionCount = 0
	
	if roundi(doorTimer / 40.0) == door + 2:
		door = 0
		doorTimer = 0
		
	if door >= 0 and len(doors) > 0:
		if len(doors) > 1:
			lastDoorPos = doors[door].global_position
		doors[door].queue_free()
		doors.remove_at(door)
		
		if len(doors) > 0:
			currentDoorPos = doors[door].global_position
			
		point1.position.x -= 700
		point2.position.x -= 700
		door = -1
	
	camera.position = player.position
	playerPosition = player.global_position
	scoreLabel.text = str(score)
	
	if player.throwStrength == 0:
		strengthBar.visible = false
	else:
		strengthBar.visible = true
		strengthBar.value = player.throwStrength * 100
	
	if potionSpawnCooldown >= 5 and potionCount < maxPotionCount:
		potionSpawnCooldown = 0
		var localPotion = potionPickUp.instantiate()
		localPotion.global_position = Vector2(currentDoorPos.x + randi_range(100, 500), currentDoorPos.y)
		print(localPotion.global_position)
		localPotion.type = getRandomPotion()
		localPotion.color = getPotionSpriteColor(localPotion.type)
		localPotion.quantity = randi_range(5, 15)
		add_child(localPotion)
	
	if enemySpawnCooldown >= 7 and enemyCount < maxEnemyCount:
		enemySpawnCooldown = 0
		var localEnemy
		
		if roundi(timer) < 30:
			localEnemy = walker.instantiate()
		else:
			localEnemy = getRandomEnemy().instantiate()
			
		localEnemy.global_position = Vector2(lastDoorPos.x + randi_range(-300, 300), lastDoorPos.y)
		add_child(localEnemy)
		
	for node in get_children():
		if node.is_in_group("walker"):
			localEnemyCount += 1
		if node.is_in_group("potionPickUp"):
			localPotionCount += 1
			
	if not localEnemyCount == enemyCount:
		enemyCount = localEnemyCount
		
	if not localPotionCount == potionCount:
		potionCount = localPotionCount
			
	for index in range(len(player.items)):
		items[index].modulate = getPotionSpriteColor(player.items[index])
		
		if player.items[index] == "none":
			items[index].texture = load("res://art/nothing.png")
		else:
			items[index].texture = load("res://art/potion.png")
			
		if index == player.selectedItem:
			itemLabels[index].add_theme_font_size_override("font_size", 24)
		else:
			itemLabels[index].add_theme_font_size_override("font_size", 16)
			
		items[index].get_node("Quantity").text = str(player.itemQuantity[index])
	
func when_item_changes(itemName): 
	print(itemName)
	
func _on_player_potion_toss(potionName, strength):
	var localPotion = potion.instantiate()
	localPotion.global_position = potionCreationPos.global_position
	localPotion.strength = strength * 2
	localPotion.type = potionName
	add_child(localPotion)
			

func _on_player_die():
	get_tree().change_scene_to_packed(gameOver)
	
func playEnemyDie(pos : Vector2):
	$EnemyDie.position = pos
	$EnemyDie.play()
	
func getRandomPotion():
	var type = ""
	var randomize = randi_range(0, 7)
	
	match randomize:
		0:
			type = "Damage Potion"
		1:
			type = "Slowness Potion"
		2: 
			type = "Speed Potion"
		3: 
			type = "Jump Potion"
		4:
			type = "Gravity Potion"
		5:
			type = "Levitation Potion"
		6:
			type = "Ensmallen Potion"
		7:
			type = "Enbiggen Potion"
	return type
			
func getPotionSpriteColor(potion : String):
	var color : Color
	
	match potion:
		"none":
			color = Color(1, 1, 1)
		"Damage Potion":
			color = Color8(255, 170, 255)
		"Slowness Potion":
			color = Color8(185, 208, 255)
		"Speed Potion":
			color = Color8(135, 227, 170)
		"Jump Potion":
			color = Color8(234, 200, 103)
		"Gravity Potion":
			color = Color8(242, 147, 0)
		"Levitation Potion":
			color = Color8(255, 255, 255)
		"Ensmallen Potion":
			color = Color8(128, 0, 174)
		"Enbiggen Potion":
			color = Color8(255, 0, 200)
			
	return color
	
func getRandomEnemy():
	var randomize = randi_range(0, 19)
	
	if randomize < 15:
		return walker
	elif randomize > 15 and randomize < 19:
		return juggernaut
	else:
		return para

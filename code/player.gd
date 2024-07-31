extends RigidBody2D

signal selected_item_change(itemName : String)
signal potion_toss(potionName: String, strength: float)
signal die

var speed : int = 3000
var maxVelocity = 750
var jumpPower : int = 700
var jumps : int = 1
var isOnGround : bool

var throwingTime : float 
var detectingWall : bool
var wallPos : Vector2

var dt : float = 0

var items = ["none", "none", "none"]
var itemQuantity = [0, 0, 0]
var selectedItem = 0

var throwStrength : float
var throwCooldown : float
var throwOverflow : bool

var spriteAnimations = [
	preload("res://art/player0.png"), 
	preload("res://art/player1.png"),
	preload("res://art/player2.png"),
	preload("res://art/player3.png")
] 
var animDelay = 0
var animInter = 0
@onready var sprite = $Sprite2D

var actualScale : float
var affectedByPotion : bool
var potionEffectCooldown : float
var lastEffectEntered : String
var throwing : bool 

var stunnedFor = 0

func _ready():
	selected_item_change.emit(items[selectedItem])

func _process(delta):
	dt = delta
	
	if stunnedFor > 0:
		$Stunned.emitting = true
		stunnedFor -= delta
	else:
		$Stunned.emitting = false
		
	if animDelay > 0:
		animDelay -= delta
	elif animDelay < 0:
		animDelay = 0
		
	if throwing:
		sprite.texture = spriteAnimations[3]
	else:
		if animDelay == 0 and abs(linear_velocity.x) > 0.01:
			if animInter == 2:
				animInter = 0
			else:
				animInter += 1

			sprite.texture = spriteAnimations[animInter]
			animDelay = 0.1
		elif animDelay > 0 and abs(linear_velocity.x) <= 0.01:
			sprite.texture = spriteAnimations[0]
	
	if position.x < get_global_mouse_position().x:
		sprite.flip_h = false
	elif position.x > get_global_mouse_position().x:
		sprite.flip_h = true
	
	if throwCooldown > 0:
		throwCooldown -= delta
	
	var currentSelectedItem = selectedItem
	
	if Input.is_action_just_pressed("press1"):
		selectedItem = 0
	
	if Input.is_action_just_pressed("press2"):
		selectedItem = 1
		
	if Input.is_action_just_pressed("press3"):
		selectedItem = 2
		
	for item in range(len(itemQuantity)):
		if itemQuantity[item] == 0:
			items[item] = "none"
		elif itemQuantity[item] > 100:
			itemQuantity[item] = 100
		
	if Input.is_action_just_pressed("scrollWheelDown"):
		if selectedItem == 0:
			selectedItem = 2
		else:
			selectedItem -= 1
			
	if Input.is_action_just_pressed("scrollWheelUp"):
		if selectedItem == 2:
			selectedItem = 0
		else:
			selectedItem += 1
			
	if Input.is_action_pressed("leftClick") and not items[selectedItem] == "none" and not stunnedFor > 0:
		if not throwOverflow:
			throwStrength += delta * 2
		else:
			throwStrength -= delta / 2
		
		if throwStrength >= 1.5:
			throwOverflow = true
		elif throwStrength < 0:
			throwOverflow = false
			
	if affectedByPotion and potionEffectCooldown == 0:
		match lastEffectEntered:
			"Slowness Potion":
				maxVelocity -= 10
				potionEffectCooldown = 0.1
			"Speed Potion":
				maxVelocity += 10
				potionEffectCooldown = 0.1
			"Jump Potion":
				jumpPower += 20
				potionEffectCooldown = 0.1
			"Gravity Potion":
				jumpPower -= 20
				gravity_scale += 0.1
				potionEffectCooldown = 0.1
			"Levitation Potion":
				apply_impulse(Vector2(0, -700))
				gravity_scale -= 0.1
				potionEffectCooldown = 2.5
			"Ensmallen Potion":
				global_scale -= Vector2(0.2, 0.2)
				actualScale -= 0.2
				potionEffectCooldown = 0.3
				
				for child in get_children():
					if child is Node2D:
						child.scale *= global_scale
						child.transform.origin *= global_scale
				
			"Enbiggen Potion":
				global_scale += Vector2(0.2, 0.2)
				actualScale += 0.2
				potionEffectCooldown = 0.3
				
				for child in get_children():
					if child is Node2D:
						child.scale *= global_scale
						child.transform.origin *= global_scale
			
	if Input.is_action_just_released("leftClick") and throwCooldown <= 0 and not items[selectedItem] == "none":
		potion_toss.emit(items[selectedItem], throwStrength)
		throwStrength = 0
		throwOverflow = false
		throwCooldown = 0.25
		$ThrowPotion.play()
		sprite.texture = spriteAnimations[3]
		animDelay = 0.5
		itemQuantity[selectedItem] -= 1
	
	if not selectedItem == currentSelectedItem:
		selected_item_change.emit(items[selectedItem])

func _integrate_forces(state):
	if linear_velocity.x < maxVelocity:
		if Input.is_action_pressed("moveRight") and not stunnedFor > 0 and throwingTime <= 0:
			apply_impulse(Vector2(speed * dt, 0))
				
	if linear_velocity.x > -maxVelocity and not stunnedFor > 0 and throwingTime <= 0:
		if Input.is_action_pressed("moveLeft"):
			apply_impulse(Vector2(-speed * dt, 0))
			
	if jumps > 0 and linear_velocity.y > -750 and not stunnedFor > 0 and throwingTime <= 0:
		if Input.is_action_just_pressed("jump"):
			apply_impulse(Vector2(0, -jumpPower))
			$JumpParticles.emitting = true
			$Jump.play()
			jumps -= 1
		
func _on_body_entered(body):
	if body.is_in_group("regainJump"):
		jumps = 1
		throwingTime = 0
		isOnGround = false
		
	if body.is_in_group("bad"):
		$Death.play()
		emit_signal("die")
		
	if body.is_in_group("potionEffect"):
		affectedByPotion = true
		lastEffectEntered = body.potionType
		print(body.potionType)
		
	if body.is_in_group("potionPickUp"):
		print(body.get_parent().type)
		
		# this code is gonna make you cringe if you werent already
		if items[0] == "none":
			items[0] = body.get_parent().type
			itemQuantity[0] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
		elif body.get_parent().type == items[0]:
			itemQuantity[0] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
				
		if items[1] == "none":
			items[1] = body.get_parent().type
			itemQuantity[1] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
		elif body.get_parent().type == items[1]:
			itemQuantity[1] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
		
		if items[2] == "none":
			items[2] = body.get_parent().type
			itemQuantity[2] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
		elif body.get_parent().type == items[2]:
			itemQuantity[2] += body.get_parent().quantity
			body.get_parent().queue_free()
			$PickUpPotion.play()
			return
		
	if body.is_in_group("juggernaut"):
		var wayToGo : Vector2
		throwingTime = 0.35
		
		if body.global_position.x > position.x:
			wayToGo.x = -1
		elif body.global_position.x < position.x:
			wayToGo.x = 1
		else:
			wayToGo.x = 0
		
		wayToGo.y = -1
		
		if detectingWall:
			if wallPos.x > position.x:
				wayToGo.x *= 3
				wayToGo.y *= 3
			elif wallPos.x < position.x:
				wayToGo.x *= -3
				wayToGo.y *= 3
		
		print(Vector2(body.global_scale.x * 1000 * wayToGo.x, body.global_scale.y * 1000 * wayToGo.y))
		apply_impulse(Vector2(body.global_scale.x * 1000 * wayToGo.x, body.global_scale.y * 1000 * wayToGo.y))
	
	if body.is_in_group("para"):
		stunnedFor = 1
	
	if body.is_in_group("walker"):
		var wayToGo : Vector2
		throwingTime = 0.25
		
		if body.global_position.x > position.x:
			wayToGo.x = -1
		elif body.global_position.x < position.x:
			wayToGo.x = 1
		else:
			wayToGo.x = 0
		
		wayToGo.y = -1
		
		if detectingWall:
			if wallPos.x > position.x:
				wayToGo.x *= 3
				wayToGo.y *= 3
			elif wallPos.x < position.x:
				wayToGo.x *= -3
				wayToGo.y *= 3
		
		print(Vector2(body.global_scale.x * 500 * wayToGo.x, body.global_scale.y * 500 * wayToGo.y))
		apply_impulse(Vector2(body.global_scale.x * 500 * wayToGo.x, body.global_scale.y * 500 * wayToGo.y))

func _on_wall_detector(area):
	if area.is_in_group("wall"):
		detectingWall = true
		wallPos = area.global_position

func _on_wall_detector_exited(area):
	if area.is_in_group("wall"):
		detectingWall = false

func _on_area_2d_area_exited(area):
	if area.is_in_group("potionEffect"):
		affectedByPotion = false
	
	if area.is_in_group("regainJump"):
		isOnGround = false

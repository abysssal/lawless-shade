extends RigidBody2D

signal selected_item_change(itemName : String)
signal potion_toss(potionName: String, strength: float)
signal die

var speed : int = 3000
var maxVelocity = 750
var jumpPower : int = 700
var jumps : int = 1

var throwingTime : float 
var detectingWall : bool
var wallPos : Vector2

var dt : float = 0

var items = ["Damage Potion", "none", "none"] 
var selectedItem = 0

var throwStrength : float
var throwCooldown : float
var throwOverflow : bool

func _ready():
	selected_item_change.emit(items[selectedItem])

func _process(delta):
	dt = delta
	
	if throwCooldown > 0:
		throwCooldown -= delta
	
	var currentSelectedItem = selectedItem
	
	if Input.is_action_just_pressed("press1"):
		selectedItem = 0
	
	if Input.is_action_just_pressed("press2"):
		selectedItem = 1
		
	if Input.is_action_just_pressed("press3"):
		selectedItem = 2
		
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
			
	if Input.is_action_pressed("leftClick"):
		if not throwOverflow:
			throwStrength += delta * 2
		else:
			throwStrength -= delta / 2
		
		if throwStrength >= 1.5:
			throwOverflow = true
		elif throwStrength < 0:
			throwOverflow = false
			
	if Input.is_action_just_released("leftClick") and throwCooldown <= 0:
		potion_toss.emit(items[selectedItem], throwStrength)
		throwStrength = 0
		throwOverflow = false
		throwCooldown = 0.25
	
	if not selectedItem == currentSelectedItem:
		selected_item_change.emit(items[selectedItem])

func _integrate_forces(state):
	if linear_velocity.x < maxVelocity:
		if Input.is_action_pressed("moveRight") and throwingTime <= 0:
			apply_impulse(Vector2(speed * dt, 0))
				
	if linear_velocity.x > -maxVelocity and throwingTime <= 0:
		if Input.is_action_pressed("moveLeft"):
			apply_impulse(Vector2(-speed * dt, 0))
			
	if jumps > 0 and linear_velocity.y > -750 and throwingTime <= 0:
		if Input.is_action_just_pressed("jump"):
			apply_impulse(Vector2(0, -jumpPower))
			jumps -= 1
		
func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("regainJump"):
		jumps = 1
		throwingTime = 0
		
	if body.is_in_group("bad"):
		emit_signal("die")
		
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

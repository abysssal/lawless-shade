extends RigidBody2D

signal selected_item_change(itemName : String)

@onready var itemLabel = $"./"

var speed : int = 3000
var jumpPower : int = 500
var jumps : int = 2

var dt : float = 0

var items = ["none", "big balls", "big dicks"]
var selectedItem = 0

func _init():
	selected_item_change.emit(items[selectedItem])

func _process(delta):
	dt = delta
	
	var currentSelectedItem = selectedItem
	
	if Input.is_action_just_pressed("press1"):
		selectedItem = 0
	
	if Input.is_action_just_pressed("press2"):
		selectedItem = 1
		
	if Input.is_action_just_pressed("press3"):
		selectedItem = 2
		
	if Input.is_action_just_pressed("scrollWheelDown"):
		if selectedItem == 2:
			selectedItem = 0
		else:
			selectedItem -= 1
			
	if Input.is_action_just_pressed("scrollWheelUp"):
		if selectedItem == 0:
			selectedItem = 1
		else:
			selectedItem += 1
			
	if not selectedItem == currentSelectedItem:
		selected_item_change.emit(items[selectedItem])

func _integrate_forces(state):
	if linear_velocity.x < 500:
		if Input.is_action_pressed("moveRight"):
			print("right")
			if linear_velocity.x != 0:
				apply_impulse(Vector2(speed * dt, 0))
			else:
				apply_impulse(Vector2(speed * dt, 0))
				
	if linear_velocity.x > -500:
		if Input.is_action_pressed("moveLeft"):
			print("left")
			if linear_velocity.x != 0:
				apply_impulse(Vector2(-speed * dt, 0))
			else:
				apply_impulse(Vector2(speed * dt, 0))
			
	if jumps > 0 and linear_velocity.y > -750:
		if Input.is_action_just_pressed("jump"):
			print("jump")
			apply_impulse(Vector2(0, -jumpPower))
			jumps -= 1
		
	print(linear_velocity)

func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("regainJump"):
		jumps = 2

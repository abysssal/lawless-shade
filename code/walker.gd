extends RigidBody2D

var speed = randi_range(2000, 4000)
var maxVelocity = randi_range(200, 500)

var jumpPower = randi_range(500, 1000)
var jumps = 0
var jumpTime = 0
var jumpTimer = randi_range(1, 10)

var targetPos = Vector2(1, 0)
var randScale = randf_range(0.5, 1.5)

var hp : int

var affectedByPotion : bool
var lastEffectEntered : String
var potionEffectCooldown = 0

@onready var root = get_node("..")

func _ready():
	randScale = randf_range(5, 15) / 10
	global_scale = Vector2(randScale, randScale)
	
	for child in get_children():
		if child is Node2D:
			child.scale *= global_scale
			child.transform.origin *= global_scale
			
	hp = roundi(randScale * 100)
			
	print(hp)

func _process(delta):
	jumpTime += delta
	
	if hp <= 0:
		queue_free()
	
	if roundi(root.playerPosition.x) > roundi(position.x):
		targetPos.x = 1
	elif roundi(root.playerPosition.x) < roundi(position.x):
		targetPos.x = -1
	else:
		targetPos.x = 0
		
	if roundi(root.playerPosition.y - 0.5) <= roundi(position.y):
		targetPos.y = 1
	else:
		targetPos.y = 0
		
	if affectedByPotion and potionEffectCooldown == 0:
		match lastEffectEntered:
			"Damage Potion":
				hp -= 10
				print("damage potion, hp: " + str(hp))
				
		potionEffectCooldown = 0.1
	elif affectedByPotion and potionEffectCooldown > 0:
		potionEffectCooldown -= delta
	else:
		potionEffectCooldown = 0

func _integrate_forces(state):
	if abs(linear_velocity.x) < maxVelocity and not targetPos.x == 0:
		apply_impulse(Vector2(targetPos.x * speed * get_physics_process_delta_time(), 0))
		
	if targetPos.y == 1:
		jumpTime = jumpTimer
	
	if jumpTime >= jumpTimer and jumps > 0:
		apply_impulse(Vector2(0, -jumpPower))
		jumpTime = 0
		jumpTimer = randi_range(1, 5)

func _on_bottom_body_exited(body):
	if body.is_in_group("regainJump"):
		jumpTime = jumpTimer

func _on_area_entered_area(area):
	if area.is_in_group("potionEffect"):
		affectedByPotion = true
		lastEffectEntered = area.potionType
		print(area.potionType)

func _on_area_exited_area(area):
	if area.is_in_group("potionEffect"):
		affectedByPotion = false

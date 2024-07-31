extends RigidBody2D

var speed : float = randi_range(1500, 2500)
var maxVelocity = randi_range(100, 350)

var jumpPower = randi_range(400, 800)
var jumps = 0
var jumpTime = 0
var jumpTimer = randi_range(1, 10)

var targetPos = Vector2(1, 0)
var randScale = randf_range(1, 2)
var actualScale : float

var maxHp : int
var hp : int

var spriteAnimations = [
	preload("res://art/juggernaut0.png"), 
	preload("res://art/juggernaut1.png"), 
	preload("res://art/juggernaut2.png"), 
	preload("res://art/juggernaut3.png"), 
	preload("res://art/juggernaut4.png")
] 
var animDelay = 0
var animInter = 0
@onready var sprite = $Sprite2D

var affectedByPotion : bool
var lastEffectEntered : String
var potionEffectCooldown = 0

@onready var root = get_node("..")
@onready var hpBar = $Health

func _ready():
	randScale = randf_range(10, 18) / 10
	global_scale = Vector2(randScale, randScale)
	actualScale = global_scale.x
	
	for child in get_children():
		if child is Node2D:
			child.scale *= global_scale
			child.transform.origin *= global_scale
			
	hp = roundi(randScale * 100)
	maxHp = hp
	hpBar.max_value = maxHp
	
	print(hp)

func _process(delta):
	jumpTime += delta
	
	hpBar.value = hp
	
	if animDelay > 0:
		animDelay -= delta
	elif animDelay < 0:
		animDelay = 0
		
	if animDelay == 0:
		if animInter == 4:
			animInter = 0
		else:
			animInter += 1

		sprite.texture = spriteAnimations[animInter]
		animDelay = 0.1
	
	if actualScale >= 2 or actualScale < 0.5 or maxVelocity < 0 or maxVelocity > 1000:
		hp = 0
	
	if maxHp > hp:
		hpBar.visible = true
	else:
		hpBar.visible = false
	
	if hp <= 0:
		root.score += maxHp * 10
		root.playEnemyDie(global_position)
		queue_free()
	
	if roundi(root.playerPosition.x) > roundi(position.x):
		targetPos.x = 1
		sprite.flip_h = true
	elif roundi(root.playerPosition.x) < roundi(position.x):
		targetPos.x = -1
		sprite.flip_h = false
	else:
		targetPos.x = 0
		
	if affectedByPotion and potionEffectCooldown == 0:
		match lastEffectEntered:
			"Damage Potion":
				hp -= 8
				potionEffectCooldown = 0.1
			"Slowness Potion":
				maxVelocity -= 8
				potionEffectCooldown = 0.1
			"Speed Potion":
				maxVelocity += 8
				potionEffectCooldown = 0.1
			"Jump Potion":
				jumpPower += 15
				potionEffectCooldown = 0.1
			"Gravity Potion":
				jumpPower -= 15
				gravity_scale += 0.1
				potionEffectCooldown = 0.1
			"Levitation Potion":
				apply_impulse(Vector2(0, -600))
				gravity_scale -= 0.1
				potionEffectCooldown = 5
			"Ensmallen Potion":
				global_scale -= Vector2(0.3, 0.3)
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
						
	if affectedByPotion and potionEffectCooldown > 0:
		potionEffectCooldown -= delta
	else:
		potionEffectCooldown = 0

func _integrate_forces(state):
	if abs(linear_velocity.x) < maxVelocity and not targetPos.x == 0:
		apply_impulse(Vector2(targetPos.x * speed * get_physics_process_delta_time(), 0))
		
	if jumpTime >= jumpTimer and targetPos.y > 0:
		apply_impulse(Vector2(0, -jumpPower))
		$Jump.play()
		$JumpParticles.emitting = true
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

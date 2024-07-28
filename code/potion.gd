extends RigidBody2D

@onready var potionFx = preload("res://scenes/potion_effect.tscn")
@export var type : String
@export var strength : float
var effectLifetime : float
var effectSize : Vector2
var effectLength : float 

var flyingVector : Vector2
var timeFlying = 0

func _ready():
	setPotionType()
	flyingVector = Vector2((get_global_mouse_position().x - position.x) / 10 * strength, (get_global_mouse_position().y - position.y) / 10 * strength)
	rotation = atan2(flyingVector.y, flyingVector.x) + 90 
	
func _process(delta):
	timeFlying += delta

func _integrate_forces(state):
	if timeFlying < 0.2:
		print(flyingVector)
		apply_impulse(flyingVector)
		rotation = atan2(linear_velocity.y, linear_velocity.x) + 90

func _on_body_entered(body):
	if not body.name == name:
		print(body.name)
		var localPotionFx = potionFx.instantiate()
		localPotionFx.global_position = global_position
		localPotionFx.potionColor = $Sprite2D.modulate
		localPotionFx.size = effectSize
		localPotionFx.lifetime = effectLifetime
		localPotionFx.potionType = type
		get_tree().root.add_child(localPotionFx)
		queue_free()

func setPotionType():
	match type:
		"Damage Potion":
			$Sprite2D.modulate = Color8(255, 170, 255)
			effectSize = Vector2(200, 300)
			effectLifetime = 0.5
			effectLength = 0.1
		"Slowness Potion":
			$Sprite2D.modulate = Color8(185, 208, 255)
			effectSize = Vector2(250, 300)
			effectLifetime = 1.25
			effectLength = 1
		"Speed Potion":
			$Sprite2D.modulate = Color8(135, 227, 170)
			effectSize = Vector2(150, 300)
			effectLifetime = 0.75
			effectLength = 2
		"Jump Potion":
			$Sprite2D.modulate = Color8(234, 200, 103)
			effectSize = Vector2(50, 300)
			effectLifetime = 1
			effectLength = 1
		"Gravity Potion":
			$Sprite2D.modulate = Color8(242, 147, 0)
			effectSize = Vector2(75, 300)
			effectLifetime = 1.2
			effectLength = 1.25
		"Levitation Potion":
			$Sprite2D.modulate = Color8(255, 255, 255)
			effectSize = Vector2(100, 300)
			effectLifetime = 2
			effectLength = 4
		"Ensmallen Potion":
			$Sprite2D.modulate = Color8(128, 0, 174)
			effectSize = Vector2(50, 300)
			effectLifetime = 1
			effectLength = 1
		"Enbiggen Potion":
			$Sprite2D.modulate = Color8(255, 0, 200)
			effectSize = Vector2(250, 300)
			effectLifetime = 3
			effectLength = 3
		

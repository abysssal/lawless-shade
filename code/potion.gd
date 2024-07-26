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
	print(modulate)
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

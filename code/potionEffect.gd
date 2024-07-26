extends Area2D

@onready var potionFx = preload("res://scenes/potion_effect.tscn")

var lifetime : float
var size : Vector2
var potionType : String
var potionColor : Color
var potionLength : float
var life : float = 0

func _ready():
	$CPUParticles2D.color = potionColor
	$CPUParticles2D.emission_rect_extents = Vector2(size.x / 2, 1)

func _process(dt):
	life += dt
	
	if life >= lifetime:
		$CPUParticles2D.emitting = false
		if life >= lifetime + 0.5: 
			queue_free()


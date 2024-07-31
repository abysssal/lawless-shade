extends RigidBody2D

var color : Color
var type : String
var quantity : int

func _ready():
	modulate = color
	apply_impulse(Vector2(randi_range(-500, 500), randi_range(-500, 500)))


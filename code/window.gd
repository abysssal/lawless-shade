extends Area2D

var openLevel : float = 0
var openLevelIncrements : float = 0
var maxOpenLevel : float = 0

@onready var collision = $CollisionShape2D
@onready var light = $Light

func _ready():
	for i in range(roundi(collision.shape.get_size().y / 10)):
		maxOpenLevel += 1
		
func _process(delta):
	var colorValue : float = openLevel / maxOpenLevel
	light.modulate = Color(colorValue, colorValue, colorValue)
	$PointLight2D.energy = colorValue
	
	if maxOpenLevel == openLevel:
		add_to_group("bad")

func _on_body_exited(body):
	print(body.get_groups())
	if body.is_in_group("walker"):
		openLevel += 1

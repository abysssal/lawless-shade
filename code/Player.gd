extends RigidBody2D

var speed : int = 3000
var jumpPower : int = 500
var jumps : int = 2
var dt : float = 0

func _process(delta):
	dt = delta



func _integrate_forces(state):
	if linear_velocity.x < 500:
		if Input.is_action_pressed("moveRight"):
			print("right")
			apply_impulse(Vector2(speed * dt, 0))
	
	if linear_velocity.x > -500:
		if Input.is_action_pressed("moveLeft"):
			print("left")
			apply_impulse(Vector2(-speed * dt, 0))
			
	if jumps > 0:
		if Input.is_action_just_pressed("jump"):
			print("jump")
			apply_impulse(Vector2(0, -jumpPower))
			jumps -= 1
		
	print(linear_velocity)


func _on_body_entered(body):
	if body.is_in_group("regainJump"):
		jumps = 2

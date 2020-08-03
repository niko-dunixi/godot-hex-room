extends KinematicBody

var camera_vertical_angle = 0
var mouse_sensitivity = 0.3
var velocity = Vector3()
var direction = Vector3()
const MAX_FLY_SPEED = 10
const MAX_FLY_ACCELERATION = 4

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		var vertical_change = event.relative.y * mouse_sensitivity * -1
		if vertical_change + camera_vertical_angle > -90 and vertical_change + camera_vertical_angle < 90:
			$Head/Camera.rotate_x(deg2rad(vertical_change))
			camera_vertical_angle += vertical_change
		
func _physics_process(delta):
	direction = Vector3()
	var aim = $Head/Camera.get_global_transform().basis
	if Input.is_key_pressed(KEY_W):
		direction -= aim.z
	elif Input.is_key_pressed(KEY_S):
		direction += aim.z
	if Input.is_key_pressed(KEY_A):
		direction -= aim.x
	elif Input.is_key_pressed(KEY_D):
		direction += aim.x
	direction = direction.normalized()
	
	var target = direction * MAX_FLY_SPEED
	
	velocity = velocity.linear_interpolate(target, MAX_FLY_ACCELERATION * delta)
	
	move_and_slide(velocity)

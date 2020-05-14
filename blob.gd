extends KinematicBody2D

signal blob_died

const GRAVITY 	= 400
const SPEED 	= 15
const JUMPSPEED = 100

const UP_VECTOR = Vector2(0,-1)
const is_an_enemy = true

onready var sprite 		= $AnimatedSprite
onready var ray_left 	= $RayCastLeft
onready var ray_right 	= $RayCastRight

var movement 	= Vector2(SPEED, 0)
var is_alive 	= true
var jump_x 		= 0
var direction	= 1

func _ready():
	set_animation()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_alive == false: return
	movement.y += GRAVITY * delta
	
	if is_on_floor():
		if sprite.animation == "jump":
			on_landing()
		else:
			movement.y = 0
			if is_on_wall() or is_over_abyss():
				jump()
		
	move_and_slide_with_snap(movement, Vector2(0,1),UP_VECTOR)
	

	
func is_over_abyss():
	if movement.x < 0:
		ray_left.force_raycast_update()
		return ray_left.get_collider() == null
	else:
		ray_right.force_raycast_update()
		return ray_right.get_collider() == null
	
	
func on_stomp():
	if self.name == "BlobGod":
		prints("BlobGod stomped")
		is_alive = false
		sprite.play("die")
		emit_signal("blob_died")
	else:	
		is_alive = false
		sprite.play("die")
		
	
func on_landing():
	sprite.play("walk")
	movement.x = SPEED * direction
	if jump_x == floor(position.x):
		turn()

func turn():
	direction 		*= -1
	movement.x 		= SPEED	* direction	
	sprite.flip_h 	= !sprite.flip_h 
	
func jump():
	sprite.play("jump")	
	movement.y 	= -JUMPSPEED
	movement.x 	= SPEED * direction * 4
	jump_x 		= floor(position.x)
	
func set_animation():
	sprite.play("walk")
	pass

func is_in_air():
	return is_on_floor() == false

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "die":
		queue_free()


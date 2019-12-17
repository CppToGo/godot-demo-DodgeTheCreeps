extends Area2D
signal hit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export var speed = 400 #How fast th e player will move (pixels/sec)
var screen_size #Size of the game window

#Add this variable to hold the clicked positiond
var target=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	pass # Replace with function body.
	
func _process(delta):
	var velocity = Vector2()
	#Move towards the target and stiop when close.
	if position.distance_to(target) > 10 :
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	#Remove keyboard Controls.
	#if Input.is_action_pressed("ui_right"):
	#	velocity.x += 1
	#if Input.is_action_pressed("ui_left"):
	#	velocity.x -= 1
	#if Input.is_action_pressed("ui_down"):
	#	velocity.y += 1
	#if Input.is_action_pressed("ui_up"):
	#	velocity.y -= 1
	if velocity.length() > 0:
		if velocity.x != 0 :
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0 :
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = velocity.y > 0
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x , 0 , screen_size.x)
	position.y = clamp(position.y , 0 , screen_size.y)
	
		

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.

func start(pos):
	position = pos
	#Initial target is the start position
	target = pos
	show()
	$CollisionShape2D.disabled = false
	
func _input(event):
	if event is InputEventScreenTouch and event.pressed :
		target = event.position
		 
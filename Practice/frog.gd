extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var JUMP_VELOCITY = -450
var SPEED = 400
@onready var froganim = get_node("AnimationPlayer")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		#gravity for frog
		velocity.y += gravity * delta
		if velocity.y >0:
			if froganim.get_current_animation() != "Death":
				froganim.play("Fall")
			else:
				chase = false
	else:
		if chase:
			print(froganim.get_current_animation())
			if froganim.get_current_animation() != "Death":
				velocity.y = JUMP_VELOCITY
				froganim.play("Jump")
			else:
				chase = false
		else:
			if froganim.get_current_animation() != "Death":
				froganim.play("Idle")
	
	player = get_node("../../Player/Player")
	var direction = (player.position - self.position).normalized()
	if chase == true:
		velocity.x = direction.x *SPEED
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = false
		else:
			get_node("AnimatedSprite2D").flip_h = true
	else:
		velocity.x = 0
	
	move_and_slide()
		



func _on_player_detection_body_entered(body):
	
	if body.name == "Player":
		chase = true
		



func _on_player_detection_body_exited(body):
	
	if body.name == "Player":
		chase = false
		


func _on_player_death_body_entered(body):
	if body.name == "Player":
		froganim.play("Death")
		await get_tree().create_timer(froganim.current_animation_length).timeout

		
		self.queue_free()
		
		


func _on_player_damage_body_entered(body):
	if body.name == "Player" && froganim.get_current_animation() != "Death":
		body.health -= 2

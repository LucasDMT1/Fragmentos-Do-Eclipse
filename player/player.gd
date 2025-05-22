extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY = 1000
const SPEED = 300
const JUMP = -200

enum State {Idle, Run}

var current_state

func _ready():
	current_state = State.Idle

func _physics_process(delta):
	player_falling(delta)
	player_Idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()
	
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_Idle(delta):
	if is_on_floor():
		current_state = State.Idle
		print("State: ", State.keys()[current_state])
func player_run(delta):
	var direction = Input.get_axis("mover_left" , "mover_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x , 0 , SPEED)
		
	if direction != 0:
		current_state = State.Run
		print("State: ", State.keys()[current_state])
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_jump(delta):
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP
	
	
	
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")

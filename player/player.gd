extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY = 1000
@export var speed : int = 1000
@export var max_horizontal_speed : int = 300
@export var slow_down_speed : int = 1700

@export var jump : int = -100
@export var max_jump: int = 300
@export var jump_horizontal : int = 1000
@export var max_jump_horizontal_speed =  300

enum State {Idle, Run, Jump, Atack}

var current_state : State

var character_sprite : Sprite2D

func _ready():
	current_state = State.Idle

func _physics_process(delta : float):
	player_falling(delta)
	player_Idle(delta)
	player_run(delta)
	player_jump(delta)
	player_atack(delta)
	
	move_and_slide()
	
	player_animations()
	
	print("State: ", State.keys()[current_state])
	
func player_atack(delta):
	if Input.is_action_just_pressed("atack"):
		current_state = State.Atack
	
func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_Idle(delta : float):
	if is_on_floor():
		current_state = State.Idle
func player_run(delta : float):
	if !is_on_floor():
		return
		
	var direction = input_movement()
	
	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x , 0 , slow_down_speed * delta)
		
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true
	

func player_jump(delta : float):
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
				velocity.y = jump / delta
				velocity.y = clamp(velocity.y, -max_jump, max_jump)
				current_state = State.Jump
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)
		
func player_animations():
	if current_state == State.Idle and animated_sprite_2d.animation != "Atack":
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")
	elif current_state == State.Atack:
		animated_sprite_2d.play("Atack")
	
func input_movement():
	var direction : int = Input.get_axis("mover_left" , "mover_right")
	
	return direction


func _on_hurt_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered ", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)

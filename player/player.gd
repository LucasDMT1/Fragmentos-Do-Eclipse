extends CharacterBody2D

@onready var sword_area = $SwordArea

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_animation_player = $HitAnimationPlayer
@onready var player_death_effect = $AnimatedSprite2D

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
	sword_area.monitoring = false
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

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
	if Input.is_action_just_pressed("atack") and current_state != State.Atack:
		current_state = State.Atack
		sword_area.monitoring = true
	
func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_Idle(delta : float):
	if is_on_floor() and current_state != State.Atack and input_movement() == 0:
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
	match current_state:
		State.Idle:
			if animated_sprite_2d.animation != "Idle":
				animated_sprite_2d.play("Idle")
		State.Run:
			if animated_sprite_2d.animation != "Run":
				animated_sprite_2d.play("Run")
		State.Jump:
			if animated_sprite_2d.animation != "Jump":
				animated_sprite_2d.play("Jump")
		State.Atack:
			if animated_sprite_2d.animation != "Atack":
				animated_sprite_2d.play("Atack")
	
func input_movement():
	var direction : int = Input.get_axis("mover_left" , "mover_right")
	
	return direction

func player_death():
	var player_death_effect_instance = player_death_effect.instance() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()

func _on_hurt_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered ", body.damage_amount)
		hit_animation_player.play("hit")
		HealthManager.decrease_health(body.damage_amount)
	if HealthManager.current_health == 0:
		player_death()


func _on_sword_area_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		if body.has_method("die"):
			body.die()



func _on_animated_sprite_2d_animation_finished():
	if current_state == State.Atack:
		current_state = State.Idle
		sword_area.monitoring = false

extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const MAXFALLSPEED = 200
const MAXSPEED = 90
const JUMPFORCE = 325
const ACCEL = 20

var motion = Vector2()
var facing_right = true
var x_pos = 0
var y_pos = 0
var last_checkpoint = Vector2(x_pos, y_pos)

var last_animation = ""
var current_animation = ""

var death_count = 0

func _ready():
	pass

func _physics_process(_delta):
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if facing_right == true:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		facing_right = true
		current_animation = "Run"
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		facing_right = false
		current_animation = "Run"
	else:
		motion.x = lerp(motion.x, 0, 0.2)
		current_animation = "Idle"
		
	if Input.is_action_just_pressed("space"):
		attack()
		yield(get_node("AnimationPlayer"), "animation_finished")
		$AnimationPlayer.play("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	
	#motion negative = up
	if !is_on_floor():
		if motion.y < 0:
			current_animation = "Jump"
		elif motion.y > 0:
			current_animation = "Fall"
			if global_position.y > 250:
				die()
	
	if last_animation != current_animation:
		$AnimationPlayer.play(current_animation)
		last_animation = current_animation
	
	motion = move_and_slide(motion, UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMapCheckpoint":
			x_pos = global_position.x
			y_pos = global_position.y - 100
			last_checkpoint = Vector2(x_pos, y_pos)	
		if collision.collider.name == "TileMapWin":
			last_checkpoint = Vector2(global_position.x, global_position.y - 300)
			position = Vector2(last_checkpoint)
		
func die():
	position = Vector2(last_checkpoint)
	death_count += 1
	print(death_count)

func attack():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randi() % 2
	if rand == 0:
		$AnimationPlayer.play("Attack1")
		if facing_right == true:
			motion.x += 75
		elif facing_right == false:
			motion.x -= 75
	elif rand == 1:
		$AnimationPlayer.play("Attack2")
		if facing_right == true:
			motion.x += 200
		elif facing_right == false:
			motion.x -= 200

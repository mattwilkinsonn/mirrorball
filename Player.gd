extends CharacterBody2D

enum LookDirection {
	LEFT,
	RIGHT,
}

enum MovementState {
	WALK,
	IDLE
}

@export var speed = 100

var look_direction = LookDirection.RIGHT

var movement_state = MovementState.IDLE

# this should probably be a class but whatever
var current_lazers = {
	Global.LazerColor.RED: 0,
	Global.LazerColor.GREEN: 0,
	Global.LazerColor.BLUE: 0
}

var lazer_strength = 0
var lazer_color: Global.LazerColor
var lazer_godot_color: Color

func _ready():
	pass

func get_input():
	var mouse_position = get_global_mouse_position()
	set_look(mouse_position)
	
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	set_movement(input_direction)
	
func get_aim_direction(target: Vector2):
	return global_position.direction_to(target)
	
func get_look_direction(aim_direction: Vector2):
	if aim_direction.x < 0:
		return LookDirection.LEFT
	
	return LookDirection.RIGHT
	
func set_look(mouse_position: Vector2):
	$Lazer.target_position = (mouse_position - global_position) * 10000
	
	var aim_direction = get_aim_direction(mouse_position)

	var current_look_direction = get_look_direction(aim_direction)
	
	if current_look_direction != look_direction:
		$Sprite2D.flip_h = !$Sprite2D.flip_h
	
	look_direction = current_look_direction
	
func get_movement_state(input_direction: Vector2):
	if input_direction.length() > 0:
		return MovementState.WALK
	
	return MovementState.IDLE
	
func set_movement(input_direction: Vector2):
	var current_movement_state = get_movement_state(input_direction)
	
	movement_state = current_movement_state
	
	velocity = input_direction * speed
	

func lazer_collision(color: Global.LazerColor):
	current_lazers[color] += 1
	
func stop_lazer_collision(color: Global.LazerColor):
	current_lazers[color] -= 1

func create_mirror_lazer():
	# mvp is just go with highest color
	# todo find actual resulting color from inputs
	var strength = 0
	var max_color_count = 0
	var largest_color: Global.LazerColor
	for key in current_lazers.keys():
		var color_amount = current_lazers[key]
		strength += color_amount
		if color_amount > max_color_count:
			max_color_count = color_amount
			largest_color = key
	
	lazer_strength = strength
	lazer_color = largest_color
	lazer_godot_color = Global.LazerColorToGodotColor[lazer_color]
	
	
func _draw():
	if lazer_strength > 0:
		draw_line(Vector2.ZERO, to_local($Lazer.get_collision_point()), lazer_godot_color, lazer_strength * 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	create_mirror_lazer()
	queue_redraw()
	
func _physics_process(delta):
	get_input()

	move_and_slide()

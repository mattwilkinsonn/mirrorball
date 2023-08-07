extends Area2D

const Player = preload("res://Player.gd")

@export var SPIN: bool = true
@export var ANGULAR_VELOCITY = 5
@export var MAX_ROTATION = 40.0

var ANGULAR_VELOCITY_RAD = deg_to_rad(ANGULAR_VELOCITY)
var MAX_ROTATION_RAD = deg_to_rad(MAX_ROTATION)

var lazer_color: Global.LazerColor
var color: Color
var spin_direction: int

var negative_rotation_bound
var positive_rotation_bound

var player
var colliding_with_player: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lazer_color = Global.LazerColor.values()[randi_range(0, 2)]
	color = Global.LazerColorToGodotColor[lazer_color]
	player = get_node("/root/Main/Player")
	spin_direction = pow(-1, randi() % 2)
	negative_rotation_bound = rotation - MAX_ROTATION_RAD
	positive_rotation_bound = rotation + MAX_ROTATION_RAD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Lazer.get_collider() is Player and not colliding_with_player:
		player.lazer_collision(lazer_color)
		colliding_with_player = true
	if not $Lazer.get_collider() is Player and colliding_with_player:
		player.stop_lazer_collision(lazer_color)
		colliding_with_player = false
	
	queue_redraw()

func _draw():
	draw_line(Vector2.ZERO, to_local($Lazer.get_collision_point()), color, 1.0)
	
func _physics_process(delta):
	var angle_change = ANGULAR_VELOCITY_RAD * delta * spin_direction
	rotation = lerp_angle(rotation, rotation + angle_change, 1)
	if rotation <= negative_rotation_bound or rotation >= positive_rotation_bound:
		spin_direction *= -1
	
	

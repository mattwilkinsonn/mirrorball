extends Area2D


const Player = preload("res://Player.gd")






var lazer_color: Global.LazerColor
var color: Color

var player
var colliding_with_player: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lazer_color = Global.LazerColor.values()[randi_range(0, 2)]
	color = Global.LazerColorToGodotColor[lazer_color]
	player = get_node("/root/Main/Player")
	
	print(color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCast2D.get_collider() is Player and not colliding_with_player:
		player.lazer_collision(lazer_color)
		colliding_with_player = true
	if not $RayCast2D.get_collider() is Player and colliding_with_player:
		player.stop_lazer_collision(lazer_color)
		colliding_with_player = false
	
	queue_redraw()

func _draw():
	draw_line(Vector2.ZERO, $RayCast2D.get_collision_point() - global_position, color, 3.0)
	
	

extends Sprite

var Player = preload("res://Player.gd")

var x_pos = global_position.x
var y_pos = global_position.y

func _ready():
	pass # Replace with function body.
	
func _on_body_entered(body:Node):
	print(body, " entered")

func _on_body_exited(body:Node):
	print(body, " exited")

func _physics_process(_delta):
	if(Player.attack()):
		print(x_pos, y_pos, Player.x_pos, Player.y_pos)

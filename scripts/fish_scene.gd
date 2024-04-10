extends Area2D
class_name FishInFarm
var start_pos
var adult_weight
signal reproduction_sig

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x > 1200:
		position = start_pos
	move()

func move():
	position += Vector2(1,0)
	
func grow_up():
	pass
	
func reproduction():
	reproduction_sig.emit()
	
func show_info():
	pass
	#选中此鱼展示信息
	

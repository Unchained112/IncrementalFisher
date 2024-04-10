extends Node2D
signal get_fish(fish_info)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_fish():
	var new_fish_info :String = 'new1'
	return new_fish_info
	
	
func _on_钓场入口与快捷钓鱼键_button_down():
	#print("按下按钮")
	var new_fish_info = create_fish()
	get_fish.emit(new_fish_info)
	pass # Replace with function body.

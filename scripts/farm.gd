extends Node2D
@export var fish_scene: PackedScene
var max_volumn :int = 100
var volumn :int
var fish_list :Array[Dictionary]


# Called when the node enters the scene tree for the first time.
func _ready():
	$"背景".texture = load("res://assets/background/1.jpg")
	$"背景".position = Vector2(576,325)
	$"背景".scale = Vector2(1.125,0.887)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_fish(fish_info):
	print('fish_info:',fish_info)
	var fish = fish_scene.instantiate()
	var scale_num = randi() % 3

	fish.position = Vector2(randi()%1000,randi()%600)
	fish.scale = Vector2(scale_num,scale_num)
	add_child(fish)

func remove_fish(fish_id):
	pass

func _on_钓场入口与快捷钓鱼键_button_down():
	pass # Replace with function body.


func _on_钓场_get_fish(fish_info):
	add_fish(fish_info)

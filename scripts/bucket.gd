extends TabBar
class_name Bucket

@export var v_container: VBoxContainer
@export var fish_item: PackedScene

func add_fish(fish: Dictionary):
	var new_fish: FishInBucket = fish_item.instantiate()
	new_fish.setup(fish)
	v_container.add_child(new_fish)

extends Node2D

@onready var bucket: TabBar = $CanvasLayer/HBoxContainer/TabContainer/Bucket




func _on_button_button_down():
	bucket.add_fish(DesignData.fish_list.pick_random())

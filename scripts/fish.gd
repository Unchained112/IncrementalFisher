extends HBoxContainer
class_name FishInBucket

var fish_name: String = "bronze"
var price_per_kg: int = 10
var weight: int = 10
var toatl_price: int
var fish_sprite: TextureRect
var fish_info: Label
#@onready var fish_sprite: TextureRect = $FishSprite
#@onready var fish_info: Label = $FishInfo
var fish_image
func setup(fish: Dictionary):
	fish_sprite = $FishSprite
	fish_info = $FishInfo
	fish_sprite.texture.atlas = load(fish.path)
	fish_sprite.texture.set_region(Rect2(0, 0, fish.w, fish.h))
	print(fish_sprite.texture.region)

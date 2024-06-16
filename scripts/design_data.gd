extends Node

# 在/design_data/fish_data.xlsx中修改
# 然后在 https://imrains.gitee.io/excel-to-json/ 转json
# 复制于此
#var fish_list = [
		#{
			#"id": 0,
			#"name": "Red Fish",
			#"rarity": "white",
			#"larvae_img_path": "res://assets/graphics/SpearFishingAssetsPack/Sprites/Fish1-16x16/Red.png",
			#"init_adult_weight": 4,
			#"value_per_kg": 1,
			#"time_to_grow_up": 10,
			#"time_of_reproduction_cycle": 20
		#},
		#{
			#"id": 1,
			#"name": "Ryukin",
			#"rarity": "gold",
			#"larvae_img_path": "res://assets/graphics/SpearFishingAssetsPack/Sprites/Fish2-32x16/Orange.png",
			#"init_adult_weight": 5,
			#"value_per_kg": 2,
			#"time_to_grow_up": 15,
			#"time_of_reproduction_cycle": 30
		#}
	#]

var fish_species_porp_info = [
	{
	"id": 0,
	"species_name": "Red Fish",
	"template_scene": "res://scenes/fish/fish_temp.tscn",
	"rarity": 1,
	"larvae_length": 10,
	"init_adult_length": 50,
	"basic_length": 20,
	"time_to_grow_up": 3, 
	"growth_rate":1.5,
	"wlr": 1,
	"unit_price": 1,
	"time_of_reproduction_cycle": 3 
}
]

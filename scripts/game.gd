extends Node

@export var Fish1: PackedScene
@onready var Camera : Camera3D = $RayPickerCamera
@onready var choosen_fish
@onready var cached_fish_scenes: Dictionary
var FishList
var Coins
# Called when the node enters the scene tree for the first time.
func _ready():
	Camera.click_fish.connect(_on_click_fish)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if choosen_fish != null:
		$CanvasLayer/Control/VBoxContainer/RichTextLabel.text = 'Fish Info:' + ' \nFish Name: ' + choosen_fish.species_prop.species_name + '\nAge: ' + str("%0.3f"%choosen_fish.age) + '\nLength: ' + str("%.3f"%choosen_fish.length) + 'cm'
		if !choosen_fish.adult_flag:
			$CanvasLayer/Control/VBoxContainer/ProgressBar.value = choosen_fish.age / choosen_fish.species_prop.time_to_grow_up * 100
			$CanvasLayer/Control/VBoxContainer/ProgressBar/Label.text = '生长'
		else :
			$CanvasLayer/Control/VBoxContainer/ProgressBar.value = fmod((choosen_fish.age-choosen_fish.species_prop.time_to_grow_up) , float(choosen_fish.species_prop.time_of_reproduction_cycle))/choosen_fish.species_prop.time_of_reproduction_cycle * 100
			$CanvasLayer/Control/VBoxContainer/ProgressBar/Label.text = '繁殖'
			
	pass


func fishing():
	#钓鱼
	pass
	
func add_fish(fishid,parent = null):
	#向鱼缸中和列表中加入鱼 
	#get指令 -> add_fish() -> 计算鱼的信息 -> 根据模板实例化鱼并赋予信息，并根据信息修改贴图 -> 把整个新鱼实体？还是信息？加到list里后续管理
	
	#提取种族信息，计算成体长度
	var fish_species_prop = DesignData.fish_species_porp_info[fishid]
	
	var fish_adult_length
	if parent != null:
		fish_adult_length = parent.adult_length * fish_species_prop.growth_rate
	else:
		fish_adult_length = fish_species_prop.init_adult_length
		
	#实例化
	var template_scene_path = fish_species_prop.template_scene
	if not cached_fish_scenes.has(template_scene_path):
		cached_fish_scenes[template_scene_path] = load(template_scene_path)
	var new_fish = cached_fish_scenes[template_scene_path].instantiate()
	get_parent().add_child(new_fish)
	new_fish.position = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))*1
	new_fish.length = float(fish_species_prop.larvae_length)
	new_fish.adult_length = float(fish_adult_length)
	new_fish.grow_up_speed = (float(fish_adult_length)-float(fish_species_prop.larvae_length))/float(fish_species_prop.time_to_grow_up)
	new_fish.species_prop = fish_species_prop
	var volounm_scale = new_fish.length / float(fish_species_prop.basic_length)
	new_fish.fish_body.scale = Vector3(volounm_scale,volounm_scale,volounm_scale)
	
	new_fish.reproduct.connect(add_fish)
	
func remove_fish():
	#从鱼缸中和列表中移除鱼
	pass
	
func _on_click_fish(fish):
	choosen_fish = fish
	#print(fish)
	





func _on_addfish_button_down():
	add_fish(0)

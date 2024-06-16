extends Node3D
class_name FishTemp

@export var obstacle_dis: float = 0.8
@export var swim_speed_min: float = 0.2
@export var swim_speed_max: float = 0.6
@export var max_turn_rate: float = 5.0
@export var max_wander_angle: float = 45.0 # around 45 degree
@export var wander_probability: float = 0.15
@export var ref_point: Vector3 = Vector3(0, 0, 0)

var cur_speed: float
var cur_dir: Vector3 = Vector3(1, 0, 0)
var obstacle_detected: bool = false
var try_wander: bool = false
var look_rotation: Quaternion = Quaternion(0, 0, 0, 1)

@onready var fish_body: Node3D = $FishBody
@onready var rand_seed: float = randf()
@onready var noise_gen = FastNoiseLite.new()
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

#@onready var fish_length: float = 10.0 #储存方式还要想想
#@onready var basic_length: float = 10.0
#@onready var grow_up_speed: float = 0.02
#@onready var max_length: float = 100.0
@onready var volounm_scale: float =1

@onready var species_prop
#@onready var individual_prop = { "age": 0, "length": 10, "grow_up_speed": 0.02, "max_length": 100}

@onready var age: float = 0
@onready var length
@onready var adult_length
@onready var grow_up_speed
@onready var adult_flag: bool = false

signal reproduct

func _ready():
	anim_player.play("move")
	#print(species_prop)


func _physics_process(delta):
	wiggle()
	wander()
	avoid_obstacles()

	# update position
	position += delta * cur_speed * cur_dir
	
	age += delta
	if !adult_flag:
		grow(delta)
		if length >= adult_length:
			adult_flag = true
			print("adult")
			length = adult_length
			var reproduction_timer: Timer = Timer.new()
			reproduction_timer.wait_time = int(species_prop.time_of_reproduction_cycle)
			reproduction_timer.autostart = true
			reproduction_timer.one_shot = false
			reproduction_timer.connect("timeout", reproduction)
			add_child(reproduction_timer)
			reproduction_timer.start()
		
	volounm_scale = length / float(species_prop.larvae_length)
	fish_body.scale = Vector3(volounm_scale,volounm_scale,volounm_scale)
	


func grow(delta):
	length += grow_up_speed * delta
	
func reproduction():
	reproduct.emit(species_prop.id,self)
	


func _input(event):
	# method test
	if event.is_action("ui_down"):
		quaternion.y = 0.7

func wander():
	var speed_percent := randf()
	cur_speed = lerpf(swim_speed_min, swim_speed_max, speed_percent)

	if obstacle_detected:
		return

	if try_wander:
		try_wander = false
		if randf() < wander_probability:
			# change moving direction
			var rand_angle := randf_range(-max_wander_angle, max_wander_angle)
			var rand_rotation := Quaternion(Vector3.UP, rand_angle)
			look_rotation = rand_rotation * quaternion
#
	quaternion = quaternion.slerp(look_rotation, 0.1)
	cur_dir = transform.basis.x.normalized()

func wiggle():
	# handle animation
	pass

func avoid_obstacles():
	obstacle_detected = ray_cast.is_colliding()
	if obstacle_detected:
		var reflection_dir := cur_dir.reflect(ray_cast.get_collision_normal())
		var goal_point_dis := 1.0
		var reflection_point := ray_cast.get_collision_point() + \
					reflection_dir * 0.8
		# randomize the avoiding movement
		var goal_point := (reflection_point + ref_point) * 0.5
		var goal_dir := (goal_point - position) * 10.0
		look_rotation = Quaternion(cur_dir, goal_dir).normalized()

		# TODO: add danger level
		quaternion = quaternion.slerp(look_rotation, 0.2)


func _on_wander_timer_timeout():
	try_wander = true

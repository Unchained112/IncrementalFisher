extends Node3D
class_name FishBase

@export var obstacle_dis: float = 0.8
@export var swim_speed_min: float = 0.2
@export var swim_speed_max: float = 0.6
@export var max_turn_rate: float = 5.0
@export var max_wander_angle_y: float = 0.3 # around 30 degree
@export var max_wander_angle_z: float = 0.2
@export var wander_probability: float = 0.15
@export var ref_point: Vector3 = Vector3(0, 0, 0)

var cur_speed: float
var cur_dir: Vector3
var obstacle_detected: bool = false
var try_wander: bool = false
var try_change_speed: bool = false
var look_rotation: Quaternion = Quaternion(0, 0, 0, 1)
var speed_state: int # Fast: 1, Move: 2, Idle: 3
var can_move: bool = true

@onready var fish_body: Node3D = $FishBody
@onready var rand_seed: float = randf()
@onready var noise_gen = FastNoiseLite.new()
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var ray_cast_left: RayCast3D = $RayCast3DLeft
@onready var ray_cast_right: RayCast3D = $RayCast3DRight
@onready var ray_cast_back: RayCast3D = $RayCast3DBack
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var speed_timer: Timer = $SpeedTimer

func _ready():
	set_speed_state(2) # Move
	cur_dir = transform.basis.x.normalized()

func _physics_process(delta):
	wiggle()
	wander()
	avoid_obstacles()

	# update position
	position += delta * cur_speed * cur_dir

func _input(event):
	# method test
	if event.is_action("ui_down"):
		quaternion.y = 0.7

func wander():
	if obstacle_detected:
		return

	if try_wander:
		try_wander = false
		if randf() < wander_probability:
			# change moving direction int the xy plane
			var rand_angle_y := randf_range(-max_wander_angle_y,
				max_wander_angle_y)
			var rand_angle_z := randf_range(-max_wander_angle_z,
				max_wander_angle_z)
			var rand_rotation := Quaternion(Vector3.UP, rand_angle_y)
			rand_rotation *= Quaternion(Vector3.FORWARD, rand_angle_z)
			look_rotation = rand_rotation * quaternion

	quaternion = quaternion.slerp(look_rotation, 0.1)
	cur_dir = transform.basis.x.normalized()

func wiggle():
	if can_move == false:
		return

	if try_change_speed:
		try_change_speed = false
		if speed_state == 2: # Move
			var temp := randf()
			if temp < 0.2:
				set_speed_state(1)
			elif temp > 0.7: 
				set_speed_state(3)
			else:
				set_speed_state(2)
		elif speed_state == 3: # Idle
			if randf() < 0.6:
				set_speed_state(2)
			else: 
				set_speed_state(3)
		else: # speed_state == 1 Fast
			if randf() < 0.8:
				set_speed_state(2)
			else: 
				set_speed_state(1)

func avoid_obstacles():
	obstacle_detected = ray_cast.is_colliding()

	if (obstacle_detected and 
			ray_cast_left.is_colliding() and
			ray_cast_right.is_colliding() and
			ray_cast_back):
		if try_change_speed:
			try_change_speed = false
			if randf() < 0.3:
				set_speed_state(2)
			else:
				set_speed_state(3)
		cur_speed = 0.0
		can_move = false
		return

	if obstacle_detected:
		var reflection_dir := cur_dir.reflect(ray_cast.get_collision_normal())
		var goal_point_dis := 1.0
		var reflection_point := ray_cast.get_collision_point() + \
					reflection_dir * 0.8
		# randomize the avoiding movement
		#var goal_point := (reflection_point + ref_point) * 0.5
		#var goal_dir := (goal_point - position) * 10.0
		var goal_dir := (reflection_point - position) * 10.0
		look_rotation = Quaternion(cur_dir, goal_dir).normalized()
		var look_euler := look_rotation.get_euler()
		if look_euler.z < -1.57 or look_euler.z > 1.57:
			look_rotation *= Quaternion(cur_dir, 1.57)
		quaternion = quaternion.slerp(look_rotation, 0.2)

func set_speed_state(state: int):
	if state == 2: # Move
		speed_timer.start(2.5)
		anim_tree.set("parameters/blend_position", 0.5)
		var speed_percent := randf()
		cur_speed = lerpf(swim_speed_min, swim_speed_max, speed_percent)
	elif state == 3: # Idle
		speed_timer.start(3.6)
		anim_tree.set("parameters/blend_position", 0.0)
		cur_speed = swim_speed_min
	else: # state == 1 Fast
		speed_timer.start(1.5)
		anim_tree.set("parameters/blend_position", 1.0)
		cur_speed = swim_speed_max

func _on_wander_timer_timeout():
	try_wander = true

func _on_speed_timer_timeout():
	try_change_speed = true

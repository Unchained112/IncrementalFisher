extends Camera3D

@export var ray_distance: int = 100

@onready var ray_cast_3d: RayCast3D = $RayCast3D
signal click_fish

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_point : Vector2 = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = project_local_ray_normal(mouse_point) * ray_distance
	ray_cast_3d.force_raycast_update()
	
	#printt(ray_cast_3d.get_collider(),ray_cast_3d.get_collision_point())
	if ray_cast_3d.is_colliding():
		if Input.is_action_just_pressed("click"):
			var collider = ray_cast_3d.get_collider()
			var fish = collider.get_parent().get_parent()
			click_fish.emit(fish)
			#print(fish.fish_length)

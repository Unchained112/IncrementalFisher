shader_type spatial;

// Rendering
uniform float diffuse_light_scale: hint_range(0.0, 1.0, 0.01) = 0.12;
uniform sampler2D albedo: source_color;
uniform sampler2D toonramp: source_color;

// Animation
uniform float move_scale: hint_range(-10.0, 10.0, 0.01) = 0.0;
uniform float rot_scale: hint_range(0.0, 20.0, 0.01) = 0.0;
uniform float offset_scale = 0.1;

void vertex() {
	float body = VERTEX.x;
	VERTEX.y += sin(move_scale + body * rot_scale) * offset_scale;
} 

void fragment() {
	ALBEDO = texture(albedo, UV).xyz;
}

void light() {
	float dot_p = dot(NORMAL, LIGHT) * 0.5 + 0.5;
	dot_p = clamp(dot_p, 0.02, 0.98);

	// Ramp the color into different steps
	vec3 ramp = texture(toonramp, vec2(dot_p, 0)).xyz;
	DIFFUSE_LIGHT += ramp * LIGHT_COLOR * diffuse_light_scale;
}

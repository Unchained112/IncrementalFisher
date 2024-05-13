shader_type spatial;


uniform float diffuse_light_scale: hint_range(0.0, 1.0, 0.01) = 0.06;
uniform sampler2D albedo: source_color;
uniform sampler2D toonramp: source_color;

void vertex() {

}

void fragment() {
	ALBEDO = texture(albedo, UV).xyz;
	ROUGHNESS = 0.0;
}

void light() {
	float dot_p = dot(NORMAL, LIGHT) * 0.5 + 0.5;
	dot_p = clamp(dot_p, 0.02, 0.98);

	// Ramp the color into different steps
	vec3 ramp = texture(toonramp, vec2(dot_p, 0)).xyz;
	DIFFUSE_LIGHT += ramp * LIGHT_COLOR * diffuse_light_scale;
}

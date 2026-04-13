shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.10;
uniform float softness : hint_range(0.001, 0.2) = 0.04;
uniform vec4 border_color : source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV;

	float d1 = distance(uv, vec2(0.0, 0.0));
	float d2 = distance(uv, vec2(1.0, 0.0));
	float d3 = distance(uv, vec2(0.0, 1.0));
	float d4 = distance(uv, vec2(1.0, 1.0));

	float corner_dist = min(min(d1, d2), min(d3, d4));
	float glow = 1.0 - smoothstep(radius, radius + softness, corner_dist);

	glow *= glow;

	COLOR = vec4(border_color.rgb, glow * intensity);
}
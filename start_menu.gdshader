shader_type canvas_item;

uniform sampler2D noise_tex : source_color;

uniform float opacity : hint_range(0.0, 1.0) = 0.15;
uniform float pixel_size = 10.0;
uniform float noise_scale = 3.0;

void fragment() {
    float t = TIME;

    vec2 uv = floor(UV * pixel_size) / pixel_size;

    vec2 noise_uv = fract(uv * noise_scale + vec2(t * 0.05, t * 0.08));
    float n = texture(noise_tex, noise_uv).r;

    float rows = step(0.75, sin(uv.y * 80.0 + t * 10.0) * 0.5 + 0.5);
    float blocks = step(0.65, texture(noise_tex, fract(vec2(uv.y * 2.0, t * 0.15))).r);

    float glitch = rows * blocks;

    vec3 col = vec3(n * 0.7 + glitch * 0.5);

    COLOR = vec4(col, opacity);
}
shader_type canvas_item;

#define S smoothstep
#define IS(x, y, z) (1.0 - smoothstep(x, y, z))

// parametros desplegables en el material
uniform vec2 resolution = vec2(600.0, 400.0);
uniform vec3 line_color: source_color = vec3(0.2, 0.6, 0.2); // color de la linea
uniform float line_thickness: hint_range(0.01, 1.0, 0.01) = 0.05;
uniform float speed = 0.5;
uniform float amp_coef = 0.1;
uniform float freq_coaf = 0.5;
uniform float iterations: hint_range(1.0, 20.0, 0.1) = 5.0;

uniform float amplitude : hint_range(0, 1) = 0.5;
uniform float frequency : hint_range(0, 10) = 1.0;
uniform float time_offset : hint_range(0, 10) = 0.0;

vec3 draw_line(vec2 uv, vec3 color, float shift, float freq) {
	//return abs(uv.y) * color;
	uv.y += sin(TIME * frequency + time_offset) * amplitude;
	return IS(0.0, line_thickness * S(-0.2, 0.9, abs(uv.x)), abs(uv.y)) * color;
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x += resolution.x / resolution.y; // definir el punto medio
	float shift = TIME * speed;
	vec3 color = vec3(0.0);
	for (float i = 0.0; i < iterations; i += 1.0) {
		color += draw_line(uv, line_color, shift, 1.0);
	}
	COLOR = vec4(color, 1.0);
}

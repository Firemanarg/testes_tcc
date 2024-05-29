shader_type canvas_item;

uniform vec4 color: source_color = vec4(vec3(0.0), 1.0);
uniform float thereshold: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	COLOR.rgb = color.rgb;
	COLOR.a = color.a * thereshold;
}

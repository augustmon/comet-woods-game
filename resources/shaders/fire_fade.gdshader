shader_type canvas_item;

uniform float blinkrate : hint_range(0.0, 10.0, 0.5) = 0.1;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	float fade = abs(sin(blinkrate * TIME*4.0))-0.3;
	
	COLOR = vec4(input_color.r+0.4,input_color.g,input_color.b, fade);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}

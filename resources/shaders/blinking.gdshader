shader_type canvas_item;


uniform float red : hint_range(0.0,1.0,0.1) = 1.0;
uniform float green : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float blue : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float speed : hint_range(1.0, 20.0, 1.0) = 1.0;
// Runs on each pixel 
	// UV is a constant with reference to each pixel position, normalised to 0.0-1.0
void fragment() {
	vec4 input_colour = texture(TEXTURE, UV);
	
	float fast_time = TIME * speed;
	float gradient_red = abs(sin(fast_time + UV.x * 2.0));
	float gradient_green = abs(sin(fast_time + UV.y * 2.0));
	float blink_rate = abs(sin(fast_time + 5.0));

	
	// UV value is determined for each pixel
	//COLOR = vec4(0.9, UV.x, UV.y, 1.0);	 
	//COLOR = vec4(0.9, UV.y, UV.x, UV.x/UV.y);
	COLOR = vec4(gradient_red*input_colour.r*red, gradient_green*input_colour.g, input_colour.b * blue, input_colour.a * blink_rate);
	
	
	//COLOR = vec4(abs(sin(fast_time + UV.x * 6.0)), 0.1,0.1,1.0);
}

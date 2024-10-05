shader_type canvas_item;

uniform vec2 offset_in_pixels;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 background_color : source_color;
uniform vec4 shadow_color : source_color;

void fragment() {
	vec4 input_texture = texture(SCREEN_TEXTURE, UV);

	COLOR = vec4(input_texture.r + 0.3, input_texture.g-0.5, input_texture.b-0.5, input_texture.a);


}

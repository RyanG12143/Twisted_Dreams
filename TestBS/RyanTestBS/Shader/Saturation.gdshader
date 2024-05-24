shader_type spatial;

uniform float saturation = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void vertex() {

}


void fragment() {
	vec4 currentColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	ALBEDO = currentColor.rgb;
	ALPHA = currentColor.a;
	ALBEDO = mix(vec3(dot(ALBEDO, vec3(0.299, 0.587, 0.114))), ALBEDO, saturation);
}
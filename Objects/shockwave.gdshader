shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float size;
uniform float thickness;
uniform float offset;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV =  (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio,1.0) + vec2(0.5, 0.0);
	float mask = (1.0 -  smoothstep(size-0.1, size, length(scaledUV - center)))
	* smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	//vec4 texr = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.1, 0.0));
	//vec4 texg = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0,0.1));
	//vec4 texb = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.1, 0.1));
	//vec4 mycolor = vec4(texr.r, texg.g, texb.b, 1.0);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + disp);
	//COLOR = vec4( texture(SCREEN_TEXTURE, SCREEN_UV + offset).r, 
	//	texture(SCREEN_TEXTURE, SCREEN_UV).g,
	//	texture(SCREEN_TEXTURE, SCREEN_UV - offset).b, 1.0);
    //COLOR.rgb = vec3(mask);
}

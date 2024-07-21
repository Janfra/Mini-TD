shader_type canvas_item;

uniform float rotate;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation){
	float sine = sin(rotation);
	float cosine = cos(rotation);
	
	uv -= pivot;
	uv.x = uv.x * cosine - uv.y * sine;
	uv.x = uv.x * sine - uv.y * cosine;
	uv += pivot;
	
	return uv;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 UV_sampled = rotateUV(UV, vec2(0, 0), rotate);
	
	vec4 sampled_texture = texture(TEXTURE, UV_sampled);
	COLOR.rgb = sampled_texture.rgb;
}


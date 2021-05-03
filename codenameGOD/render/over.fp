varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

// Color comparison with some error allowed
bool is_similar_color(vec4 c1, vec4 c2){
	float threshold = 0.02;
	return c1.r >= c2.r - threshold && c1.r <= c2.r + threshold && 
		   c1.g >= c2.g - threshold && c1.g <= c2.g + threshold &&
		   c1.b >= c2.b - threshold && c1.b <= c2.b + threshold &&
		   c1.a >= c2.a - threshold && c1.a <= c2.a + threshold;
}

bool other_color_in_neighborhood(lowp vec4 color, vec2 pos, vec2 size){
	vec2 positions[8];
	positions[0] = vec2(pos.x+1.0, pos.y);
	positions[1] = vec2(pos.x,     pos.y+1.0);
	positions[2] = vec2(pos.x+1.0, pos.y+1.0);
	positions[3] = vec2(pos.x-1.0, pos.y);
	positions[4] = vec2(pos.x,     pos.y-1.0);
	positions[5] = vec2(pos.x-1.0, pos.y-1.0);
	positions[6] = vec2(pos.x+1.0, pos.y-1.0);
	positions[7] = vec2(pos.x-1.0, pos.y+1.0);

	for(int i=0; i < 8; i++){
		lowp vec2 pos = positions[i] / size;
		lowp vec4 c = texture2D(texture_sampler, pos);
		if(!is_similar_color(c, color)){
			return true;
		}
	}
	
	return false;
}

void main()
{
	const vec4 letter_color = vec4(0.0, 0.078, 0.125, 1.0);

	lowp vec2 size = gl_FragCoord.xy / var_texcoord0.xy;
	lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
	lowp vec4 color = texture2D(texture_sampler, gl_FragCoord.xy / size) * tint_pm;

	if(is_similar_color(color, letter_color)){
		if(other_color_in_neighborhood(letter_color, gl_FragCoord.xy, size)) {
			color = vec4(1, 1, 1, 1);
		}
	}
	
	gl_FragColor = color;
}

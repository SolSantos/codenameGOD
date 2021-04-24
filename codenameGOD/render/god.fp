varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D original;
uniform lowp vec4 multiplier;
uniform lowp vec4 random;
uniform lowp vec4 light_pos;
uniform lowp vec4 radius;

void main(){
	vec4 mu = vec4(multiplier.xyz, 1);
	if(light_pos.x != 0.0 || light_pos.y != 0.0){
		float main_radius = radius.x + 0.002f * random.x;
		float transition_radius = main_radius + 0.03f;
		
		// Pre-multiply alpha since all runtime textures already are
		vec2 rounded_pos = floor(var_texcoord0.xy * 120.0) / 120.0;
		vec2 vdist = light_pos.xy - rounded_pos;
		vdist = vdist * vdist;
		float dist = (vdist.x * 2.2f) + vdist.y;
		float radius_sqr = main_radius * main_radius;
		if(dist <= radius_sqr){
			mu = vec4(1, 1, 1, 1);
		}
		else if(dist > radius_sqr && dist <= radius_sqr + transition_radius){
			float progress = (dist - radius_sqr) / transition_radius;
			mu = vec4(1, 1, 1, 1) - ((vec4(1, 1, 1, 1) - mu) * progress);
		}
	}
	gl_FragColor = texture2D(original, var_texcoord0.xy) * mu;
}

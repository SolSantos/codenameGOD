varying mediump vec2 var_texcoord0;
varying lowp vec4 var_face_color;
varying lowp vec4 var_outline_color;
varying lowp vec4 var_shadow_color;
varying lowp vec4 var_layer_mask;

uniform lowp sampler2D texture_sampler;
// Areas to highlight
uniform lowp vec4 area1;
uniform lowp vec4 color1;
uniform lowp vec4 area2;
uniform lowp vec4 color2;
uniform lowp vec4 area3;
uniform lowp vec4 color3;
uniform lowp vec4 area4;
uniform lowp vec4 color4;
uniform lowp vec4 area5;
uniform lowp vec4 color5;

bool is_similar_color(vec4 c1, vec4 c2, float err_threshold){
	return c1.r >= c2.r - err_threshold && c1.r <= c2.r + err_threshold && 
	c1.g >= c2.g - err_threshold && c1.g <= c2.g + err_threshold &&
	c1.b >= c2.b - err_threshold && c1.b <= c2.b + err_threshold &&
	c1.a >= c2.a - err_threshold && c1.a <= c2.a + err_threshold;
}

bool is_inside_area(vec4 rect, vec2 pos){
	return pos.x >= rect.x && pos.x <= rect.x + rect.z && pos.y >= rect.y && pos.y <= rect.y + rect.w;
}

void main()
{
	lowp float is_single_layer = var_layer_mask.a;
	lowp vec3 t                = texture2D(texture_sampler, var_texcoord0.xy).xyz;
	float face_alpha           = t.x * var_face_color.w;
	lowp vec4 result_color = (var_layer_mask.x * face_alpha * vec4(var_face_color.xyz, 1.0) +
	var_layer_mask.y * vec4(var_outline_color.xyz, 1.0) * var_outline_color.w * t.y * (1.0 - face_alpha * is_single_layer) +
	var_layer_mask.z * vec4(var_shadow_color.xyz, 1.0) * var_shadow_color.w * t.z * (1.0 - min(1.0, t.x + t.y) * is_single_layer));

	// High error threshold to capture the antialiasing pixels
	if(is_similar_color(result_color, vec4(0, 0, 0, 1), 0.7)){
		if(is_inside_area(area1, gl_FragCoord.xy)){
			result_color = color1;
		}
		else if(is_inside_area(area2, gl_FragCoord.xy)){
			result_color = color2;
		}
		else if(is_inside_area(area3, gl_FragCoord.xy)){
			result_color = color3;
		}
		else if(is_inside_area(area4, gl_FragCoord.xy)){
			result_color = color4;
		}
		else if(is_inside_area(area5, gl_FragCoord.xy)){
			result_color = color5;
		}
	}

	gl_FragColor = result_color;
}

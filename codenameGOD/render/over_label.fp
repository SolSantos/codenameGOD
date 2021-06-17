varying mediump vec2 var_texcoord0;
varying lowp vec4 var_face_color;
varying lowp vec4 var_outline_color;
varying lowp vec4 var_shadow_color;
varying lowp vec4 var_layer_mask;

uniform lowp sampler2D texture_sampler;

#define DECLARE_AREA_VARS(n) \
uniform lowp vec4 area##n; \
uniform lowp vec4 color##n; \
uniform lowp vec4 use_gradient##n; \
uniform lowp vec4 from_color##n; \
uniform lowp vec4 to_color##n; 

// Areas to highlight
DECLARE_AREA_VARS(1);
DECLARE_AREA_VARS(2);
DECLARE_AREA_VARS(3);


bool is_similar_color(vec4 c1, vec4 c2, float err_threshold){
	return c1.r >= c2.r - err_threshold && c1.r <= c2.r + err_threshold && 
	c1.g >= c2.g - err_threshold && c1.g <= c2.g + err_threshold &&
	c1.b >= c2.b - err_threshold && c1.b <= c2.b + err_threshold &&
	c1.a >= c2.a - err_threshold && c1.a <= c2.a + err_threshold;
}

bool is_inside_area(vec4 rect, vec2 pos){
	return pos.x >= rect.x && pos.x <= rect.x + rect.z && pos.y >= rect.y && pos.y <= rect.y + rect.w;
}

lowp vec4 transform_color(vec4 area, vec2 pos, vec4 color, vec4 use_gradient, vec4 from_color, vec4 to_color){
	if(use_gradient.x == 0.0){
		return color;
	} else {
		float progress = (pos.x - area.x) / area.z;
		lowp vec4 color_diff = to_color - from_color;
		return from_color + (color_diff * progress);
	}
}

#define TRANSFORM_IF_INSIDE(n, v2, output) if(is_inside_area(area##n, v2.xy)){ \
	output = transform_color(area##n, v2, color##n, use_gradient##n, from_color##n, to_color##n); \
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
		TRANSFORM_IF_INSIDE(1, gl_FragCoord.xy, result_color);
		TRANSFORM_IF_INSIDE(2, gl_FragCoord.xy, result_color);
		TRANSFORM_IF_INSIDE(3, gl_FragCoord.xy, result_color);
	}

	gl_FragColor = result_color;
}

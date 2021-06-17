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
DECLARE_AREA_VARS(4);
DECLARE_AREA_VARS(5);


bool is_similar_color(vec4 c1, vec4 c2, float err_threshold){
	return c1.r >= c2.r - err_threshold && c1.r <= c2.r + err_threshold && 
	c1.g >= c2.g - err_threshold && c1.g <= c2.g + err_threshold &&
	c1.b >= c2.b - err_threshold && c1.b <= c2.b + err_threshold &&
	c1.a >= c2.a - err_threshold && c1.a <= c2.a + err_threshold;
}

bool is_inside_area(vec4 rect, vec2 pos){
	return pos.x >= rect.x && pos.x <= rect.x + rect.z && pos.y >= rect.y && pos.y <= rect.y + rect.w;
}

#define TRANSFORM_IF_INSIDE(n, v2, output) if(is_inside_area(area##n, v2.xy)){ \
	if(use_gradient##n.x == 0.0){ \
		output = color##n; \
	} else { \
		float progress = (v2.x - area##n.x) / area##n.z; \
		lowp vec4 color_diff = to_color##n - from_color##n; \
		output = from_color##n + (color_diff * progress); \
	} \
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
		TRANSFORM_IF_INSIDE(4, gl_FragCoord.xy, result_color);
		TRANSFORM_IF_INSIDE(5, gl_FragCoord.xy, result_color);
	}

	gl_FragColor = result_color;
}

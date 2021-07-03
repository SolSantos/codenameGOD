varying mediump vec2 var_texcoord0;
varying lowp vec4 var_face_color;
varying lowp vec4 var_outline_color;
varying lowp vec4 var_shadow_color;
varying lowp vec4 var_layer_mask;

uniform lowp sampler2D texture_sampler;

#define DECLARE_AREA_VARS(n) \
uniform lowp vec4 area##n; \
uniform lowp vec4 color##n; \
uniform lowp vec4 to_color##n; 

// Areas to highlight
DECLARE_AREA_VARS(1);
DECLARE_AREA_VARS(2);
DECLARE_AREA_VARS(3);
DECLARE_AREA_VARS(4);

uniform lowp vec4 use_gradient;

bool is_similar_color(vec4 c1, vec4 c2, float err_threshold){
	return c1.r >= c2.r - err_threshold && c1.r <= c2.r + err_threshold && 
	c1.g >= c2.g - err_threshold && c1.g <= c2.g + err_threshold &&
	c1.b >= c2.b - err_threshold && c1.b <= c2.b + err_threshold &&
	c1.a >= c2.a - err_threshold && c1.a <= c2.a + err_threshold;
}

bool is_inside_area(vec4 rect, vec2 pos){
	return pos.x >= rect.x && pos.x <= rect.x + rect.z && pos.y >= rect.y && pos.y <= rect.y + rect.w;
}

lowp vec4 get_base_color(vec2 pos){
	lowp vec2 coord = pos / (gl_FragCoord.xy / var_texcoord0.xy);
	lowp float is_single_layer = var_layer_mask.a;
	lowp vec3 t                = texture2D(texture_sampler, coord).xyz;
	float face_alpha           = t.x * var_face_color.w;
	return (var_layer_mask.x * face_alpha * vec4(var_face_color.xyz, 1.0) +
	var_layer_mask.y * vec4(var_outline_color.xyz, 1.0) * var_outline_color.w * t.y * (1.0 - face_alpha * is_single_layer) +
	var_layer_mask.z * vec4(var_shadow_color.xyz, 1.0) * var_shadow_color.w * t.z * (1.0 - min(1.0, t.x + t.y) * is_single_layer));
}

vec4 get_area_color(lowp vec4 area, lowp vec2 pos, lowp vec4 color, lowp vec4 to_color, float use_gradient){	
	lowp vec4 base_color = get_base_color(pos);
	
	// High error threshold to capture the antialiasing pixels
	if(!is_similar_color(base_color, vec4(0, 0, 0, 1), 0.7)) return base_color;
	if(use_gradient == 0.0)                                  return color;

	float area_progress = (pos.x - area.x) / area.z;
	lowp vec4 color_diff = to_color - color;
	return color + (color_diff * area_progress);
}

void main()
{
	lowp vec4 result_color = get_base_color(gl_FragCoord.xy);
	bool inside_area1 = is_inside_area(area1, gl_FragCoord.xy);
	bool inside_area2 = is_inside_area(area2, gl_FragCoord.xy);
	bool inside_area3 = is_inside_area(area3, gl_FragCoord.xy);
	bool inside_area4 = is_inside_area(area4, gl_FragCoord.xy);
	bool inside_any_area = inside_area1 || inside_area2 || inside_area3 || inside_area4;
	
	if(inside_any_area){
		if(inside_area1) result_color = get_area_color(area1, gl_FragCoord.xy, color1, to_color1, use_gradient[0]);
		if(inside_area2) result_color = get_area_color(area2, gl_FragCoord.xy, color2, to_color2, use_gradient[1]);		
		if(inside_area3) result_color = get_area_color(area3, gl_FragCoord.xy, color3, to_color3, use_gradient[2]);
		if(inside_area4) result_color = get_area_color(area4, gl_FragCoord.xy, color4, to_color4, use_gradient[3]);
	}
	
	gl_FragColor = result_color;
}

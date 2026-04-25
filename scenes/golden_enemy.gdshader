shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
// Используй только целые числа (1.0, 2.0) для идеальной четкости
uniform float line_thickness : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	if (col.a < 0.1) {
		discard;
	}

	// Округляем до ближайшего целого пикселя
	float thick = floor(line_thickness + 0.5);
	vec2 size = TEXTURE_PIXEL_SIZE * thick;
	
	// Проверяем соседей по четырем сторонам
	float neighbor_alpha = 1.0;
	neighbor_alpha = min(neighbor_alpha, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a);
	neighbor_alpha = min(neighbor_alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
	neighbor_alpha = min(neighbor_alpha, texture(TEXTURE, UV + vec2(0.0, -size.y)).a);
	neighbor_alpha = min(neighbor_alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);

	// Если хотя бы один сосед прозрачный — это край
	if (neighbor_alpha < 1.0) {
		COLOR = line_color;
	} else {
		COLOR = col;
	}
}
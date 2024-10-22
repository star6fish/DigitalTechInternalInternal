shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float wave_amplitude = 0.05;
	float wave_speed = 2.0;
	float wave_period = 2.8;
	
	float waves = UV.y * 20.0 + sin(UV.x * 20.0 / wave_period + 1.0 * wave_speed * TIME)
			 * wave_amplitude - wave_amplitude;
	COLOR.a = step(0.5, waves) - 0.2;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

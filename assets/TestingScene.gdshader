shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float Wave_Amplitude = 0.05;
	float Wave_Speed = 2.0;
	float Wave_Period = 2.8;
	
	float waves = UV.y * 20.0 + sin(UV.x * 20.0 / Wave_Period + 1.0 * Wave_Speed * TIME) * Wave_Amplitude - Wave_Amplitude;
	COLOR.a = step(0.5, waves) - 0.2;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

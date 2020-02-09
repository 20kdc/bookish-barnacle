uniform float musicTime;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	// Each texture vector is the bytes of the frame as R/G/B/A.
	// The data is 80x60 pixel data, 1bpp, MSB rightmost.
	// So byte-wise it's 10x60, vector-wise... well, 4 doesn't divide so well into it
	// so it's even more cursed

	// CONSTANTS {
	int screenWidth = 80;
	int screenHeight = 60;
	int frameVectors = (screenWidth * screenHeight) / 32;
	int scale = 10;
	int frameCount = 7777;
	float fps = 24.0;
	// }

	// ALL COORDINATES MUST DERIVE FROM HERE {
	int pixelId = (int(screen_coords.x) / scale) + ((int(screen_coords.y) / scale) * screenWidth); // 0 - 4799
	int frame = int(musicTime * fps);
	// }

	int byteId = pixelId / 8; // 0 - 599
	int byteSubPixelId = pixelId - (byteId * 8); // 0 - 7
	int vectorId = byteId / 4; // 0 - 149
	int vectorSubByteId = byteId - (vectorId * 4); // 0 - 3
	// So to get a particular vector, we write...
	vec4 targetVector = Texel(tex, vec2((float(vectorId) + 0.5) / float(frameVectors), (float(frame) + 0.5) / float(frameCount)));
	// Then to get a particular byte...
	float targetByte = 0.0;
	if (vectorSubByteId == 0)
		targetByte = targetVector.r;
	if (vectorSubByteId == 1)
		targetByte = targetVector.g;
	if (vectorSubByteId == 2)
		targetByte = targetVector.b;
	if (vectorSubByteId == 3)
		targetByte = targetVector.a;
	// Then to extract a particular bit...
	int targetByteAsInt = int(targetByte * 255.9);
	// Divide by powers of 2 N times (so for 7, it's a divide by 128)
	for (int i = 0; i < byteSubPixelId; i++)
		targetByteAsInt /= 2;
	// Perform % 2
	targetByteAsInt -= (targetByteAsInt / 2) * 2;
	// And to display...
	if (targetByteAsInt > 0)
		return vec4(1.0, 1.0, 1.0, 1.0);
	return vec4(0.0, 0.0, 0.0, 1.0);
}

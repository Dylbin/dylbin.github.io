// Based on https://www.shadertoy.com/view/Mtl3DN

void mainImage (out vec4 c, in vec2 p) {
	vec3 R = iResolution, f = vec3 ((2. * p - R.xy) / R.y, 0);
	f *= 5.;
	float r = cos (dot (floor (f), R));
	R = step (-.8, -cos (f * 6.3));
	c = 3. * fract (r + vec4 (0, .3, .7, 0)) * R.x * R.y * (1. - length (fract (f) - .5)) * cos (r * iGlobalTime);
}

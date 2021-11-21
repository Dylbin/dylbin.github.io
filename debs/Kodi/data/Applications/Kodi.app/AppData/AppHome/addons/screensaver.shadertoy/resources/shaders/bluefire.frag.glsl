// Taken from https://www.shadertoy.com/view/4dlGR2

// by @301z
// noise 3D by by inigo quilez

float noise( in vec2 xx )
{
	vec3 x = vec3(xx,0.0);
    vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);

	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = texture( iChannel0, (uv+0.5)/256.0, -100.0 ).yx;
	return mix( rg.x, rg.y, f.z );
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 7; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	const vec3 c1 = vec3(0.1, 0.0, 0.0);
	const vec3 c2 = vec3(0.7, 0.0, 0.0);
	const vec3 c3 = vec3(0.2, 0.0, 0.0);
	const vec3 c4 = vec3(1.0, 0.9, 0.0);
	const vec3 c5 = vec3(0.1);
	const vec3 c6 = vec3(0.9);
	vec2 p = fragCoord.xy * 8.0 / iResolution.xx;
	float q = fbm(p - iTime * 0.1);
	vec2 r = vec2(fbm(p + q + iTime * 0.7 - p.x - p.y), fbm(p + q - iTime * 0.4));
	vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
	fragColor = vec4(c * -cos(1.57 * fragCoord.y / iResolution.y), 1.0);
}

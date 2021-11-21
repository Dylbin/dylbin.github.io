// Taken from https://www.shadertoy.com/view/lsSGWw

#define ITERATIONS 12
#define SPEED 10.0
#define DISPLACEMENT 0.05
#define TIGHTNESS 10.0
#define YOFFSET 0.1
#define YSCALE 0.25
#define FLAMETONE vec3(50.0, 5.0, 1.0)

float shape(in vec2 pos) // a blob shape to distort
{
	return clamp( sin(pos.x*3.1416) - pos.y+YOFFSET, 0.0, 1.0 );
}

float noise( in vec3 x ) // iq noise function
{
	vec3 p = floor(x);
    vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
	vec2 rg = textureLod( iChannel0, (uv+ 0.5)/256.0, 0.0 ).yx;
	return mix( rg.x, rg.y, f.z ) * 2.0 - 1.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	float nx = 0.0;
	float ny = 0.0;
	for (int i=1; i<ITERATIONS+1; i++)
	{
		float ii = pow(float(i), 2.0);
		float ifrac = float(i)/float(ITERATIONS);
		float t = ifrac * iTime * SPEED;
		float d = (1.0-ifrac) * DISPLACEMENT;
		nx += noise( vec3(uv.x*ii-iTime*ifrac, uv.y*YSCALE*ii-t, 0.0)) * d * 2.0;
		ny += noise( vec3(uv.x*ii+iTime*ifrac, uv.y*YSCALE*ii-t, iTime*ifrac/ii)) * d;
	}
	float flame = shape( vec2(uv.x+nx, uv.y+ny) );
	vec3 col = pow(flame, TIGHTNESS) * FLAMETONE;

    // tonemapping
    col = col / (1.0+col);
    col = pow(col, vec3(1.0/2.2));
    col = clamp(col, 0.0, 1.0);

	fragColor = vec4(col, 1.0);
}

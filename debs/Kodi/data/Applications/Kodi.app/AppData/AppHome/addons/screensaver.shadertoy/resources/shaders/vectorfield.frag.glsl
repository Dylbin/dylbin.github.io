// Taken from https://www.shadertoy.com/view/XsSGDc

#define SIZE (iResolution.x/12.) // cell size in texture coordinates
#define ZOOM (2. *256./iResolution.x)
float STRIP  = 1.;    // nbr of parallel lines per cell
float V_ADV  = 1.;    // velocity
float V_BOIL = .5;    // change speed
float t;

bool key_toggle(int ascii)
{ return (texture(iChannel1,vec2((.5+float(ascii))/256.,0.75)).x > 0.);}

bool CONT , FLOW ,ATTRAC; // A: draw field or attractor ?

vec3 flow( vec2 uv) {
   	vec2 iuv = floor(SIZE*(uv)+.5)/SIZE;
	vec2 fuv = 2.*SIZE*(uv-iuv);

	vec2 pos = .01*V_ADV*vec2(cos(t)+sin(.356*t)+2.*cos(.124*t),sin(.854*t)+cos(.441*t)+2.*cos(.174*t));	if (CONT) iuv=uv;
	vec3 tex = 2.*texture(iChannel0,iuv/(ZOOM*SIZE)-pos).rgb-1.;
	float ft = fract(t*V_BOIL)*3.;
	if      (ft<1.) tex = mix(tex.rgb,tex.gbr,ft);
	else if (ft<2.) tex = mix(tex.gbr,tex.brg,ft-1.);
	else            tex = mix(tex.brg,tex.rgb,ft-2.);
	return (FLOW) ? vec3(tex.y,-tex.x,tex.z): tex;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    t = iTime;
 	CONT   = key_toggle(67); // C: is field interpolated in cells ?
 	FLOW   = key_toggle(70); // F: flow or gradient ?
 	ATTRAC = key_toggle(65); // A: draw field or attractor ?

    vec2 uv = fragCoord / iResolution.y;
	vec3 col;

    if (ATTRAC) {
    	vec2 tex = uv;
    	for(int i=0; i<15; i++)
        	tex = tex+.03*flow(tex).xy;
    		col = texture(iChannel2,tex).rgb;
    } else {
   		vec2 iuv = floor(SIZE*(uv)+.5)/SIZE;
		vec2 fuv = 2.*SIZE*(uv-iuv);
    	vec3 tex = flow(uv);
   		float v = fuv.x*tex.x+fuv.y*tex.y;
		// v = length(fuv);
		v = sin(STRIP*v);
		col = vec3(1.-v*v*SIZE) * mix(tex,vec3(1.),.5);
    }

	// col = tex;
	fragColor = vec4(col,1.0);
}

//Taken from https://www.shadertoy.com/view/XssGD8

/*** Uses noise / fbm apparatus from Clouds by iq on shadertoy ***/

float pi = 3.14159;


mat3 m = mat3( 0.0,  0.8,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return 1.0 - sqrt(res);
}

float fbm( vec3 p )
{
    float f;    
    f  = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.0130;
    f += 0.1250*noise( p ); p = m*p*2.0370;
    // enable smallest component for more wiggliness
    // f += 0.0625*noise( p );
    // f /= 0.9375
    f /= 0.875;
    return f;
}

float nat(in vec2 q, in float z, in float mx) {
   return mx * noise(vec3(q, z)) + (1.0 - mx) * fbm(vec3(q, z));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
  vec2 mouse = vec2(1.0 - iMouse.x / iResolution.x, 1.0 - iMouse.y / iResolution.y);
  vec3 col = vec3 (0., 0., 0.);
  
  float s = 1.0 / ((1.0 + mouse.y) * 45.0);
  float fbmz = 1.0 + 0.1 * iTime;
  vec2 p = (fragCoord.xy * s);

  float as = (4.0 * (1.0 - mouse.y) + (3.0 * (1.0 - mouse.x))) + 7.5;
  float pdir = nat(p, fbmz, mouse.x) * 2.0 * pi * as;
  float d = as * 1.0 / length(iResolution);
  vec2 dp = vec2(d*sin(pdir), d * cos(pdir));
  vec2 q = p + dp;
  vec2 q2 = p - dp;
  float qdir = nat(q, fbmz, mouse.x) * 2.0 * pi * as;
  pdir = nat(q2, fbmz, mouse.x) * 2.0 * pi * as;
  vec2 c = (q2 + q) / 2.0;
  float pql = length(q - q2);

  float mdir = (pdir + qdir)/2.0;
  float ddir = mod((qdir - pdir)/2.0, pi * 2.0);
  float tdd = tan(ddir);
  vec2 co = vec2(pql * sin(mdir) / tdd, pql * cos(mdir) / tdd);
  float ro = length(q2 - c + co);

  float rf = .25 + (0.2 * (1.0 - mouse.x));
  if (ro < rf) {
    col += normalize(vec3(cos(ro/ddir),  1.0 - sin((ro/rf) * pi/2.0), 1.0 - ro/rf/ddir));
    col *= (1.0 - (ro/rf));
  } 
  fragColor = vec4(col, 1.0);
}

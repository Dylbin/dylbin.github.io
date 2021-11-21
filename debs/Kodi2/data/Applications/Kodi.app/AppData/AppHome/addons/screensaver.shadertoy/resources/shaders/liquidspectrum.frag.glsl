// from https://www.shadertoy.com/view/4sjXRG

float ltime;

float noise(vec2 p)
{
  return sin(p.x*10.) * sin(p.y*(3. + sin(ltime/11.))) + .2;
}

mat2 rotate(float angle)
{
  return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}


float fbm(vec2 p)
{
  p *= 1.1;
  float f = 0.;
  float amp = .5;
  for( int i = 0; i < 3; i++) {
    mat2 modify = rotate(ltime/50. * float(i*i));
    f += amp*noise(p);
    p = modify * p;
    p *= 2.;
    amp /= 2.2;
  }
  return f;
}

float pattern(vec2 p, out vec2 q, out vec2 r) {
  q = vec2( fbm(p + vec2(1.)),
	    fbm(rotate(.1*ltime)*p + vec2(3.)));
  r = vec2( fbm(rotate(.2)*q + vec2(0.)),
	    fbm(q + vec2(0.)));
  return fbm(p + 1.*r);

}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
  vec2 p = fragCoord.xy / iResolution.xy;
  ltime = iTime;
  float ctime = iTime + fbm(p/8.)*40.;
  float ftime = fract(ctime/6.);
  ltime = floor(ctime/6.) + (1.-cos(ftime*3.1415)/2.);
  ltime = ltime*6.;
  vec2 q;
  vec2 r;
  float f = pattern(p, q, r);
  vec3 col = hsv2rgb(vec3(q.x/10. + ltime/100. + .4, abs(r.y)*3. + .1, r.x + f));
  float vig = 1. - pow(4.*(p.x - .5)*(p.x - .5), 10.);
  vig *= 1. - pow(4.*(p.y - .5)*(p.y - .5), 10.);
  fragColor = vec4(col*vig,1.);
}

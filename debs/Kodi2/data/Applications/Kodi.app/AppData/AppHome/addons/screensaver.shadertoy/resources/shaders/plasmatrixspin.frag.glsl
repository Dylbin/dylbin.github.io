// from https://www.shadertoy.com/view/Md2XR3

#define PI 3.1415926535897932384626433832795

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float pulse = 1.;        // pulse: on/off
    float mag = 80.;

    float gs = iResolution.x / 20.;
    float ar = iResolution.x / iResolution.y;
    float t =0.2*iTime;

    if (pulse != 0.) {
        pulse = sqrt( abs( mod( t, .4 ) - .2 ) ) * 16.;
        mag = 160.;
    }
    vec2 s =iResolution.xy/mag+pulse;

    // correct aspect ratio
    vec2 p =fragCoord.xy/iResolution.x;

    if (pulse != 0.) {
        p *= s-s/2.;         // scale
    }

    // rotate
    float sa =sin(t);
    float ca =clamp(cos(t * 4.),-.9,.9);
    vec2  rp =vec2( p.x*ca - p.y*sa, p.x*sa + p.y*ca );
    if (pulse != 0.) { p = rp; }
    else { p = rp * mag * .1;  }

    // calculate the cumulative value of several sine functions
    float v =sin(p.x+.8*t)+.5*sin(p.y+.8*t)+.5*sin(p.x+p.y+.9*t);
    p += s/2.*vec2(sin(t/.9),cos(t/.6));
    v += sin(sqrt(p.x*p.x+p.y*p.y+1.)+t);

    // color blending
    float R =sin(.2 *PI*v),
          G =cos(.75*PI*v),
          B =sin(.9 *PI*v);

    // restricted color palette (nice effect)
    // code by McRam (https://www.shadertoy.com/view/ld2XRG)
    R = ceil(R*255. /  8.) *  8. / 256.;
    G = ceil(G*255. / 16.) * 16. / 256.;
    B = ceil(B*255. /  8.) *  8. / 256.;

    if(mod(R,16.) < 1.) R =G*.5+.5;
    vec3 col =vec3(R,G,B);

    // grid
    col *= 0.4 * 1./length( sin( 1.*.1 * gs*p.x ) );
    col *= 0.8 * 1./length( sin( ar*.1 * gs*p.y ) );

    // deinterlaced scanlines
    col *= .33 * length( sin( 5. * p.y * gs ) );

    col =clamp(col,vec3(.0),vec3(1.));           // safe range
    fragColor = vec4(col,1.);
}

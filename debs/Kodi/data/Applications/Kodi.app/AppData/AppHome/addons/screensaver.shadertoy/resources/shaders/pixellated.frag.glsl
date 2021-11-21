// from https://www.shadertoy.com/view/4tjGWy

// sin() that returns 0-1
float nsin(float a)
{
    return (sin(a)+1.)/2.;
}
float ncos(float a)
{
    return (cos(a)+1.)/2.;
}


// return 0-1
float plasma_a(vec2 uv, float t, vec2 lbound, vec2 ubound)
{
    vec2 p1 = vec2(nsin(t * 1.3), nsin(t * 1.9));
    vec2 p2 = vec2(nsin(t * 1.2), nsin(t * 2.2));
    p1 = (p1 * (ubound - lbound)) + lbound;
    p2 = (p2 * (ubound - lbound)) + lbound;

    return
        (nsin(length(p1 - uv))
        + nsin(length(p2 - uv))
        + nsin(uv.x / 3.)
        + nsin(uv.y / 2.)
        ) / 4.
        ;
}

// like smootherstep, but returns 0.0 at both edges, and 1.0 in the center (instead of a ramp, it's a hill)
float tri_step(float lbound, float ubound, float val)
{
    float halfRange = (ubound - lbound) / 2.0;
    val -= lbound;// shift down to 0.0 - range
    val -= halfRange;// shift down to -halfrange - halfrange
    val = abs(val);// make inverted triangle
    val = halfRange - val;// invert it so it's the kind of triangle we want (0 at the ends)
	val = val / halfRange;// scale triangle to 0-1
    val = clamp(val, 0.0, 1.0);
    return val;
}


// convert a 1D value to color, mixing channels
vec3 a_to_color(float a)
{
    return vec3(
        tri_step(0.,0.75, 1.-a),
        tri_step(0.12,0.95, 1.-a),
        tri_step(0.4,1.0, 1.-a)
    );
}


vec2 getuv_centerX(vec2 fragCoord, vec2 newTL, vec2 newSize, out float vignetteAmt)
{
    vec2 ret = vec2(fragCoord.x / iResolution.x, (iResolution.y - fragCoord.y) / iResolution.y);// ret is now 0-1 in both dimensions

    // vignette. return 0-1
    vec2 vignetteCenter = vec2(0.5, 0.5);// only makes sense 0-1 values here
    if(iMouse.z > 0.)
        vignetteCenter = vec2(iMouse.x / iResolution.x, (iResolution.y - iMouse.y) / iResolution.y);// ret is now 0-1 in both dimensions;
	vignetteAmt = 1.0 - distance(ret, vignetteCenter);
//    vignetteAmt = pow(vignetteAmt, 1.);

    ret *= newSize;// scale up to new dimensions
    float aspect = iResolution.x / iResolution.y;
    ret.x *= aspect;// orig aspect ratio
    float newWidth = newSize.x * aspect;
    return ret + vec2(newTL.x - (newWidth - newSize.x) / 2.0, newTL.y);
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 lbound = vec2(0., 0.);
    vec2 ubound = vec2(10., 10.);
    float vignetteAmt;
	vec2 uv = getuv_centerX(fragCoord, vec2(0.), vec2(10.), vignetteAmt);

    // background
    fragColor = vec4(1.,1.,1.,1.);

    // pixellate effect
    //const float pixelCount = 18.;
    float pixelSize = 44./iResolution.x * ubound.x;// pixels wide always.

    if(iMouse.x > 0.)
        pixelSize = (iMouse.x+12.)/iResolution.x * ubound.x;// pixels wide always.

    vec2 plasma_uv = floor((uv / pixelSize) + 0.5) * pixelSize;// pixellated uv coords

    // plasma
    float a = plasma_a(plasma_uv, iTime, lbound, ubound);
    fragColor = vec4(a_to_color(a), 1.0);

    // distance to pixel center
    const float pi2 = 3.14159 * 2.0;
    float pixelBorderFX = ncos(uv.x / pixelSize * pi2);
    pixelBorderFX = min(pixelBorderFX, ncos(uv.y / pixelSize * pi2));
    pixelBorderFX = pow(pixelBorderFX, 0.1);
    fragColor.rgb *= pixelBorderFX;

    // apply vignette
    fragColor.rgb *= ((vignetteAmt + 0.1) * 2.) - 0.3;
    fragColor.rgb = clamp(fragColor.rgb, 0.,1.);
}

// from https://www.shadertoy.com/view/XtXGW2

#define time (iTime*.2)

// Fuzzy circle with radius .5 centered at (.5, .5).
float circle(in vec2 p)
{
    float r = .5;
    vec2 center = vec2(r, r);
    float d = distance(p, center);
    return step(d, r) * pow(1.-d, 4.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    uv.x *= iResolution.x/iResolution.y;

    // Move up and zoom in..
    uv.y += 1.;
    uv *= .5;

    float sets[5];

    // First set:
    vec2 p = uv;
    p.x += sin(3.*p.y)*sin(2.*p.x + time);
    sets[0] = circle(mod(p, .2)*7.);

    // Second set:
    p = uv;
    p.y += sin(10.*p.y)*sin(2.3*p.x + .8*time);
    sets[1] = circle(mod(p*.6, .2)*7.);

    // Third set:
    p = uv;
    p.y += sin(10.*p.x)*sin(2.3*p.y + 2.*time);
    p.x += sin(p.y)*sin(p.x) + sin(time);
    sets[2] = circle(mod(p*.4, .2)*4.);

    // Fourth set:
    p = uv;
    p.y += sin(5.*p.x)*sin(2.*p.y + 1.4*time);
    p.x += sin(5.*p.y)*sin(p.x) + sin(time);
    sets[3] = circle(mod(p, .4)*3.);

    // Fifth set:
    p = uv;
    p.x += sin(2.*uv.y)*sin(5.*uv.x + 2.5*time);
    p.y += sin(2.*uv.x)*sin(5.*uv.x + 2.0*time);
    sets[4] = circle(mod(p, .2)*5.);

    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    fragColor.xy += sets[0];
    fragColor.yz += sets[1];
    fragColor.xz += sets[2];
    fragColor.y += 0.5*sets[3];
    fragColor.xyz += vec3(0.2, 0.4, 0.7)*sets[4];
    fragColor.w = 1.;
}

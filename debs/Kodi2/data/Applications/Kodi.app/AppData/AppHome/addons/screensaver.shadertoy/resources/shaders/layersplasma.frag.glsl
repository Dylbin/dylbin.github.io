// from https://www.shadertoy.com/view/MlsGD7

// this shader was written from scratch by digorydoo, 2015.

float plasma (vec2 p, float t)
{
    return clamp (sin (p.x*1.9 + cos (p.y*4.2 + t))
                + cos (p.y*1.9 - sin (p.x*4.2 + t))
                + 0.3, 0.0, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = 2.0*(fragCoord.xy / iResolution.xy) - vec2 (0.5, 0.5);
    uv.x *= iResolution.x / iResolution.y;
    float t = iTime;

    float grey = plasma (uv, t);
    float prox = 1.0;
    float alpha = 1.0;

    for (int i = 0; i < 5; i++)
    {
        if (grey < 0.5) { alpha *= 0.5; prox *= 0.8; }
        uv = uv*1.7 + vec2 (sin (t), 0.0);
        t *= 0.7;
        grey = mix (grey, grey*plasma (uv, t), alpha);
    }

	fragColor = 2.0 * grey * mix (
        vec4 (1.0, 1.0, 0.5, 1.0), vec4 (0.15, 0.25, 0.4, 1.0), prox);
}

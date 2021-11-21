// based on https://www.shadertoy.com/view/4d2XzG#

vec2 getNewUV( vec2 uv, vec2 pos, float radius, float strength, out float dist)
{
	vec2 fromUVToPoint = pos - uv;
	dist = length( fromUVToPoint );

	float mag = (1.0 - (dist / radius)) * strength;
	mag *= step( dist, radius );

	return uv + (mag * fromUVToPoint);
}

vec4 proceduralTexture2D( vec2 uv, vec2 resolution )
{
	vec2 fragCoord = (uv  * resolution.x );
	vec3 brightColor = vec3( 1.0, 1.0, 1.0 );
	vec3 darkColor = vec3( 0.0, 0.0, 0.0 );
	vec2 p = floor( (fragCoord.xy / resolution.x) * 10.0 );


	float t = mod(p.x + p.y, 2.0) * 10.0;
	vec3 color = mix( darkColor, brightColor, t);
	return vec4( color, 1.0 );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = (fragCoord.xy / iResolution.xy) * 2.0 - 1.0;
	uv.x *= iResolution.x / iResolution.y;

	float radius = 0.50;

	float ct = cos( iTime / 3.0 );
	float st0 = sin( iTime / 3.0 );
	float st1 = sin( iTime );

	vec2 origin = vec2( 0.0, 0.0 );
	float x = origin.x + ( ct * st0) * 2.70;
	float y = origin.y + ( st1 ) * 0.50;
	vec2 pos = vec2(x,y);


	float dist = 0.0;
	vec2 newUV = getNewUV( uv, pos, radius, 0.5, dist);

	float start = 0.42;
	float glowT = sin(iTime)*0.5 + 0.5;
	float outlineRadius = radius +  (1.0-glowT)*0.01 + (glowT * 0.08);
	vec4 highlight = vec4( 0.00, 0.00, 0.00, 1.0 );
	float t = (outlineRadius - start) / max( (dist - start), 0.01);
	highlight = mix( vec4( 0.00, 0.00, 0.00, 1.0 ), vec4( 0.00, 0.50, 0.80, 1.0 ), t);

	vec4 color = proceduralTexture2D( newUV, iResolution.xy ) + highlight;
	color.a = 1.0;

	fragColor = color;

}

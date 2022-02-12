#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform vec4 u_shadeColor;

void main()
{
vec2 tc = v_texCoord.xy;

vec2 p = vec2(1.0, 0.0);
float time=CC_Time.g*2.0;
float waveScale=50.0;
float wavePower=0.5;
float xOffset = cos(time + tc.y*waveScale)*0.01*wavePower*tc.y;
float yOffset = tc.y * 0.08*wavePower* (1.0+cos(time + tc.y*waveScale*0.5));
vec2 uv = vec2(tc.x + xOffset, tc.y + yOffset);

vec3 col = texture2D(u_texture, uv).xyz;
float r = (1.0-tc.y);
vec3 gradient = vec3(u_shadeColor.r*r, u_shadeColor.g*r, u_shadeColor.b*r);
gl_FragColor = vec4(col*gradient, u_shadeColor.a*r);
}

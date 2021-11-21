#version 100

precision mediump float;

uniform sampler2D tex;

varying vec2 vs_tex_coord;

void main()
{
  gl_FragColor = vec4(texture2D(tex, vs_tex_coord).rgb, 1.0);
}

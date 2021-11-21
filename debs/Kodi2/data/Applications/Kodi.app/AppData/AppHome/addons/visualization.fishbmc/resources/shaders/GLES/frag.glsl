#version 100

precision mediump float;

// Uniforms
uniform sampler2D u_texture;

// Varyings
varying vec2 v_coord;

void main ()
{
  gl_FragColor = texture2D(u_texture, v_coord);
}

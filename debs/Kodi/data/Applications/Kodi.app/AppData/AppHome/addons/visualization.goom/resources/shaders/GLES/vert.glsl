#version 100

uniform mat4 u_projModelMat;

attribute vec2 in_position;
attribute vec2 in_tex_coord;

varying vec2 vs_tex_coord;

void main()
{
  gl_Position = u_projModelMat * vec4(in_position, 0.0, 1.0);
  vs_tex_coord = in_tex_coord;
}

#version 150

uniform mat4 u_projModelMat;

in vec2 in_position;
in vec2 in_tex_coord;
smooth out vec2 vs_tex_coord;


void main()
{
  gl_Position = u_projModelMat * vec4(in_position.x, in_position.y, 0.0, 1.0); 

  vs_tex_coord = in_tex_coord;
}

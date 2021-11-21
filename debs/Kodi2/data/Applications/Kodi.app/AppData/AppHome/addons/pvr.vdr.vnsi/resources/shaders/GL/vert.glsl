#version 150

in vec4 a_pos;
in vec2 a_coord;

out vec2 v_coord;

void main()
{
  gl_Position = a_pos;
  v_coord = a_coord;
}

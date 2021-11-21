#version 150

uniform mat4 u_modelViewProjectionMatrix;

in vec4 a_position;

void main()
{
  gl_Position = u_modelViewProjectionMatrix * a_position;
}

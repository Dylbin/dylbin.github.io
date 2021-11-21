#version 100

uniform mat4 u_modelViewProjectionMatrix;

attribute vec4 a_position;
attribute vec4 a_color;

varying vec4 v_color;

void main()
{
  gl_Position = u_modelViewProjectionMatrix * a_position;
  v_color = a_color;
}

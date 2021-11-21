#version 130

// Attributes
in vec4 a_vertex;
in vec4 a_color;
in vec2 a_coord;

// Uniforms
uniform mat4 u_projectionMatrix;
uniform mat4 u_modelViewMatrix;

// Varyings
out vec4 v_frontColor;
out vec2 v_texCoord0;

void main ()
{
  gl_Position = u_projectionMatrix * u_modelViewMatrix * a_vertex;

  v_texCoord0 = a_coord;
  v_frontColor = a_color;
}

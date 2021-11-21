#version 100

precision mediump float;

// Attributes
attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_coord;

// Uniforms
uniform mat4 u_projectionMatrix;
uniform mat4 u_modelViewMatrix;

// Varyings
varying vec4 v_frontColor;
varying vec2 v_texCoord0;

void main ()
{
  gl_Position = u_projectionMatrix * u_modelViewMatrix * a_vertex;

  v_texCoord0 = a_coord;
  v_frontColor = a_color;
}

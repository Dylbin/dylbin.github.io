#version 150

// Uniforms
uniform sampler2D u_texture;

// Varyings
in vec2 v_coord;
in vec4 v_color;

out vec4 fragColor;

void main ()
{
  fragColor = texture(u_texture, v_coord);
}

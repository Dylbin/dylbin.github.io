#version 150

uniform sampler2D tex;
smooth in vec2 vs_tex_coord;
out vec4 color;

void main()
{
  color = vec4(texture(tex, vs_tex_coord).rgb, 1.0);
}

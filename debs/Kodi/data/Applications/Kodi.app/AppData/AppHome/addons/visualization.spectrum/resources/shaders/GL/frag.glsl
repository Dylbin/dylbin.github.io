#version 150

uniform float u_pointSize;

in vec4 v_color;

out vec4 FragColor;

void main()
{
  if (u_pointSize != 0.0)
  {
    vec2 coord = gl_PointCoord - vec2(0.5);  //from [0,1] to [-0.5,0.5]
    if(length(coord) > 0.5)                  //outside of circle radius?
      discard;
  }
  FragColor = v_color;
}

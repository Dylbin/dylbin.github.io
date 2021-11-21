// Created by inigo quilez - iq/2014
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 z = 1.15*(-iResolution.yx + 2.0*fragCoord.yx) / iResolution.y;

  vec2 an = 0.51*cos(vec2(0.0, 1.5708) + 0.1*iGlobalTime) - 0.25*cos(vec2(0.0, 1.5708) + 0.2*iGlobalTime);

  float f = 1e20;
  for (int i = 0; i<17; i++)
  {
    z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + an;
    f = min(f, dot(z, z));
  }

  f = 1.0 + log(f) / 16.0;

  fragColor = 1.0 - vec4(f, f*f, f*f*f, 0.0);
}
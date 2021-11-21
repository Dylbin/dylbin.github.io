#version 130

// Uniforms
uniform sampler2D u_texUnit;
uniform int u_textureId;

// Varyings
in vec4 v_frontColor;
in vec2 v_texCoord0;

void main()
{
  if (u_textureId != 0)
    gl_FragColor = texture2D(u_texUnit, v_texCoord0) * v_frontColor;
  else
    gl_FragColor = v_frontColor;
}

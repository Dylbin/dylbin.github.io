uniform vec4 diffuseColor;



#ifdef PT_FEATURE_TEXTURE
uniform vec2 textureScale;
uniform vec2 textureOffset;

varying vec2 texCoord;

#ifdef PT_FEATURE_ALPHA_TEST
uniform float alphaTestThreshold;
#endif // PT_FEATURE_ALPHA_TEST

#ifdef PT_FEATURE_UV1_SCALE
varying vec2 texCoord1;
#endif // PT_FEATURE_UV1_SCALE
#endif // PT_FEATURE_TEXTURE



#ifdef PT_FEATURE_SHADING
uniform vec3 eyePosition;
uniform float specularIntensity;
uniform float specularHardness;
uniform float incandescence;

varying vec3 worldPosition;
varying vec3 worldNormal;
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_SHADOWS
varying float viewDepth;
varying vec4 lightViewportTexCoordDivW;

#ifndef PT_FEATURE_SHADING
uniform float incandescence;

varying vec3 worldNormal;
#endif // PT_FEATURE_SHADING
#endif // PT_FEATURE_SHADOWS



#ifdef PT_FEATURE_FOG
uniform vec4 fogColor;
uniform float fogStartDistance;
uniform float fogEndDistance;

#ifndef PT_FEATURE_SHADOWS
varying float viewDepth;
#endif // PT_FEATURE_SHADOWS
#endif // PT_FEATURE_FOG



#if defined(PT_FEATURE_SHADING) || defined(PT_FEATURE_SHADOWS)
#pragma include PTLight.inc.fsh
#endif



void main() {
#ifdef PT_FEATURE_TEXTURE
#ifdef PT_FEATURE_UV1_SCALE
    vec4 color = texture2D(CC_Texture0, texCoord / texCoord1 / textureScale + textureOffset) * diffuseColor;
#else // PT_FEATURE_UV1_SCALE
    vec4 color = texture2D(CC_Texture0, texCoord / textureScale + textureOffset) * diffuseColor;
#endif // PT_FEATURE_UV1_SCALE
    
#ifdef PT_FEATURE_ALPHA_TEST
    if (color.a <= alphaTestThreshold) {
        discard;
    }
#endif // PT_FEATURE_ALPHA_TEST
#else // PT_FEATURE_TEXTURE

    vec4 color = diffuseColor;
#endif // PT_FEATURE_TEXTURE



#ifdef PT_FEATURE_SHADING
    vec3 d, s;
    adsModel(worldPosition, worldNormal, eyePosition, specularHardness, d, s);
    
    float inc = mix(0.5, 0.0, incandescence);
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_SHADOWS
    float shadow = 1.0;
    computeShadow(worldNormal, viewDepth, lightViewportTexCoordDivW, shadow);
    
#ifdef PT_FEATURE_SHADING
    vec4 shade = vec4(d, 1.0) * vec4(shadow, shadow, shadow, 1.0);
#else // PT_FEATURE_SHADING
    vec4 shade = vec4(shadow, shadow, shadow, 1.0);
    float inc = mix(0.5, 0.0, incandescence);
#endif // PT_FEATURE_SHADING

    gl_FragColor = color * mix(vec4(1.0, 1.0, 1.0, 0.0), shade, vec4(inc, inc, inc, 1.0));
    
#else // PT_FEATURE_SHADOWS
#ifdef PT_FEATURE_SHADING
    gl_FragColor = color * mix(vec4(1.0, 1.0, 1.0, 0.0), vec4(d, 1.0), vec4(inc, inc, inc, 1.0));
#else // PT_FEATURE_SHADING
    gl_FragColor = color;
#endif // PT_FEATURE_SHADING
#endif // PT_FEATURE_SHADOWS



#ifdef PT_FEATURE_SHADING
#ifdef PT_FEATURE_SHADOWS
    if (shadow == 1.0)
#endif // PT_FEATURE_SHADOWS

#ifdef PT_FEATURE_OPACITY_MULTIPLIED
    gl_FragColor += vec4(s, 0.0) * vec4(specularIntensity, specularIntensity, specularIntensity, 0.0) * vec4(color.a, color.a, color.a, 0.0);
#else
    gl_FragColor += vec4(s, 0.0) * vec4(specularIntensity, specularIntensity, specularIntensity, 0.0);
#endif
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_FOG
    if (viewDepth > fogStartDistance) {
        float a = (viewDepth - fogStartDistance) / (fogEndDistance - fogStartDistance);
        gl_FragColor = mix(gl_FragColor, vec4(fogColor.r, fogColor.g, fogColor.b, gl_FragColor.a), clamp(a, 0.0, 1.0));
    }
#endif // PT_FEATURE_FOG



#ifdef PT_FEATURE_OPACITY
#ifdef PT_FEATURE_OPACITY_MULTIPLIED
    if (color.a < 1.0) { //diffuseColor is used instead of color becuase transparent edges are darker with color
        gl_FragColor.r *= diffuseColor.a;
        gl_FragColor.g *= diffuseColor.a;
        gl_FragColor.b *= diffuseColor.a;
    }
    
#endif // PT_FEATURE_OPACITY_MULTIPLIED
#else // PT_FEATURE_OPACITY
    gl_FragColor.a = 1.0;
#endif // PT_FEATURE_OPACITY
}


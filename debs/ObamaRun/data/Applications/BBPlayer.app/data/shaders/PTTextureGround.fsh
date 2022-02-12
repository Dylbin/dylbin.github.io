uniform vec4 diffuseColor;
uniform int hasTexture;
uniform float specularIntensity;
uniform float specularHardness;
uniform float incandescence;
uniform vec3 eyePosition;
uniform vec4 fogColor;
uniform int fogEnabled;
uniform float fogStartDistance;
uniform float fogEndDistance;
uniform vec2 textureScale;
uniform vec2 textureOffset;

varying vec2 texCoord;
varying vec4 lightViewportTexCoordDivW;
varying vec3 worldPosition;
varying vec3 worldNormal;
varying float viewDepth;

#pragma include PTLight.inc.fsh

void main() {
    vec3 d, s;
    adsModel(worldPosition, worldNormal, eyePosition, specularHardness, d, s);
    
    float shadow = 1.0;
    computeShadow(worldNormal, viewDepth, lightViewportTexCoordDivW, shadow);
    
    float inc = mix(0.5, 0.0, incandescence);
    vec4 shade = vec4(d, 1.0) * vec4(shadow, shadow, shadow, 1.0);
    
    if (hasTexture == 1) {
        gl_FragColor = texture2D(CC_Texture0, texCoord / textureScale + textureOffset) * diffuseColor * mix(vec4(1.0, 1.0, 1.0, 0.0), shade, vec4(inc, inc, inc, 1.0));
    }
    else {
        gl_FragColor = diffuseColor * mix(vec4(1.0, 1.0, 1.0, 0.0), shade, vec4(inc, inc, inc, 1.0)); 
    }
    
    //Specular
    if (shadow == 1.0) {
        gl_FragColor += vec4(s, 0.0) * vec4(specularIntensity, specularIntensity, specularIntensity, 0.0);
    }
    
    //Fog
    if (fogEnabled == 1 && viewDepth > fogStartDistance) {
        float a = (viewDepth - fogStartDistance) / (fogEndDistance - fogStartDistance);
        gl_FragColor = mix(gl_FragColor, fogColor, clamp(a, 0.0, 1.0));
    }
    
    if (diffuseColor.a < 1.0) {
        gl_FragColor.r *= diffuseColor.a;
        gl_FragColor.g *= diffuseColor.a;
        gl_FragColor.b *= diffuseColor.a;
    }
}

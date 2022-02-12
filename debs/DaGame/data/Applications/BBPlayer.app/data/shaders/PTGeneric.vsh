attribute vec4 a_position;



#ifdef PT_FEATURE_TEXTURE
attribute vec2 a_texCoord;

varying vec2 texCoord;

#ifdef PT_FEATURE_UV1_SCALE
attribute vec2 a_texCoord1;

varying vec2 texCoord1;
#endif // PT_FEATURE_UV1_SCALE
#endif // PT_FEATURE_TEXTURE



#ifdef PT_FEATURE_SHADING
attribute vec3 a_normal;

varying vec3 worldPosition;
varying vec3 worldNormal;
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_SHADOWS
uniform mat4 worldToLightViewportTexCoord;

varying vec4 lightViewportTexCoordDivW;
varying float viewDepth;

#ifndef PT_FEATURE_SHADING
attribute vec3 a_normal;

varying vec3 worldNormal;
#endif // PT_FEATURE_SHADING
#endif // PT_FEATURE_SHADOWS



#if defined(PT_FEATURE_FOG) && !defined(PT_FEATURE_SHADOWS)
varying float viewDepth;
#endif // PT_FEATURE_FOG && !PT_FEATURE_SHADOWS



#ifdef PT_FEATURE_SKIN
const int SKINNING_JOINT_COUNT = 60;

uniform vec4 u_matrixPalette[SKINNING_JOINT_COUNT * 3];

attribute vec4 a_blendWeight;
attribute vec4 a_blendIndex;


void getPositionAndNormal(out vec4 p1, out vec4 p2, out vec4 p3) {
    float blendWeight = a_blendWeight[0];

    int matrixIndex = int(a_blendIndex[0]) * 3;
    p1 = u_matrixPalette[matrixIndex] * blendWeight;
    p2 = u_matrixPalette[matrixIndex + 1] * blendWeight;
    p3 = u_matrixPalette[matrixIndex + 2] * blendWeight;

    blendWeight = a_blendWeight[1];
    
    if (blendWeight > 0.0) {
        matrixIndex = int(a_blendIndex[1]) * 3;
        p1 += u_matrixPalette[matrixIndex] * blendWeight;
        p2 += u_matrixPalette[matrixIndex + 1] * blendWeight;
        p3 += u_matrixPalette[matrixIndex + 2] * blendWeight;

        blendWeight = a_blendWeight[2];
        
        if (blendWeight > 0.0) {
            matrixIndex = int(a_blendIndex[2]) * 3;
            p1 += u_matrixPalette[matrixIndex] * blendWeight;
            p2 += u_matrixPalette[matrixIndex + 1] * blendWeight;
            p3 += u_matrixPalette[matrixIndex + 2] * blendWeight;

            blendWeight = a_blendWeight[3];
            
            if (blendWeight > 0.0) {
                matrixIndex = int(a_blendIndex[3]) * 3;
                p1 += u_matrixPalette[matrixIndex] * blendWeight;
                p2 += u_matrixPalette[matrixIndex + 1] * blendWeight;
                p3 += u_matrixPalette[matrixIndex + 2] * blendWeight;
            }
        }
    }
}
#endif // PT_FEATURE_SKIN



void main() {    
#ifdef PT_FEATURE_SKIN
    vec4 p1, p2, p3;
    getPositionAndNormal(p1, p2, p3);
    
    vec4 position;
    position.x = dot(a_position, p1);
    position.y = dot(a_position, p2);
    position.z = dot(a_position, p3);
    position.w = a_position.w;

#if defined(PT_FEATURE_SHADING) || defined(PT_FEATURE_SHADOWS)
    vec3 normal;
    vec4 n = vec4(a_normal, 0.0);
    normal.x = dot(n, p1);
    normal.y = dot(n, p2);
    normal.z = dot(n, p3);
#endif // PT_FEATURE_SHADING || PT_FEATURE_SHADOWS
    
#else // PT_FEATURE_SKIN
    vec4 position = a_position;
    
#if defined(PT_FEATURE_SHADING) || defined(PT_FEATURE_SHADOWS)
    vec3 normal = a_normal;
#endif // PT_FEATURE_SHADING || PT_FEATURE_SHADOWS
#endif // PT_FEATURE_SKIN



#ifdef PT_FEATURE_TEXTURE
    texCoord = a_texCoord;
    texCoord.y = 1.0 - texCoord.y;
    

#ifdef PT_FEATURE_UV1_SCALE
    texCoord1 = a_texCoord1;
#endif // PT_FEATURE_UV1_SCALE
#endif // PT_FEATURE_TEXTURE



#ifdef PT_FEATURE_SHADING
    worldPosition = (CC_MVMatrix * position).xyz;
    worldNormal = (CC_NormalMatrix * normal).xyz;
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_SHADOWS
#ifndef PT_FEATURE_SHADING
    worldNormal = (CC_NormalMatrix * normal).xyz;
    
    lightViewportTexCoordDivW = worldToLightViewportTexCoord * vec4((CC_MVMatrix * position).xyz, 1.0);
    
#else // PT_FEATURE_SHADING
    lightViewportTexCoordDivW = worldToLightViewportTexCoord * vec4(worldPosition, 1.0);
#endif // PT_FEATURE_SHADING
#endif // PT_FEATURE_SHADOWS



    gl_Position = CC_MVPMatrix * position;
    
    
    
#if defined(PT_FEATURE_SHADOWS) || defined(PT_FEATURE_FOG)
    viewDepth = gl_Position.z;
#endif // PT_FEATURE_SHADOWS || PT_FEATURE_FOG
}

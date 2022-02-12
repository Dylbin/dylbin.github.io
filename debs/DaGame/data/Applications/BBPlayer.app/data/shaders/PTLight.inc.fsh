const int MAX_LIGHTS = 7;

const float TYPE_POINT = 0.0;
const float TYPE_DIRECTIONAL = 1.0;
const float TYPE_SPOT = 2.0;

#if defined(PT_FEATURE_SHADING) || defined(PT_FEATURE_SHADOWS)
uniform int lightCount;
uniform float lightType[MAX_LIGHTS];
uniform vec3 lightDirection[MAX_LIGHTS];
#endif // PT_FEATURE_SHADING || PT_FEATURE_SHADOWS



#ifdef PT_FEATURE_SHADING
uniform vec3 lightPosition[MAX_LIGHTS];
uniform vec3 lightColor[MAX_LIGHTS];
uniform float lightIntensity[MAX_LIGHTS];
uniform float lightCutOffAngle[MAX_LIGHTS];
uniform float lightInvertedRange[MAX_LIGHTS];
uniform vec3 lightAmbientColor;
#endif // PT_FEATURE_SHADING



#ifdef PT_FEATURE_SHADOWS
uniform float shadowFarPlane;
uniform float shadowIntensity;

#ifdef PT_PCF_SHADOWS
uniform sampler2DShadow shadowMapTexture;
#else // PT_PCF_SHADOWS
uniform sampler2D shadowMapTexture;
#endif // PT_PCF_SHADOWS
#endif // PT_FEATURE_SHADOWS



#ifdef PT_FEATURE_SHADING
void adsModel(const in vec3 worldPos,
              const in vec3 worldNormal,
              const in vec3 worldEye,
              const in float shininess,
              out vec3 diffuseColor,
              out vec3 specularColor)
{
    diffuseColor = lightAmbientColor;
    specularColor = vec3(0.0);

    // We perform all work in world space
    vec3 n = normalize(worldNormal);
    vec3 v = normalize(worldEye - worldPos);
    vec3 s = vec3(0.0);

    for (int i = 0; i < lightCount; ++i) {
        float att = 1.0;
        float sDotN = 0.0;

        if (lightType[i] != TYPE_DIRECTIONAL) {
            // Point and Spot lights

            // Light position is already in world space
            vec3 sUnnormalized = lightPosition[i] - worldPos;
            s = normalize(sUnnormalized); // Light direction

            // Calculate the attenuation factor
            sDotN = dot(s, n);

            if (sDotN > 0.0) {
                vec3 ldir = sUnnormalized * lightInvertedRange[i];

                att = clamp(1.0 - dot(ldir, ldir), 0.0, 1.0);

                // The light direction is in world space already
                if (lightType[i] == TYPE_SPOT) {
                    // Check if fragment is inside or outside of the spot light cone
                    if (degrees(acos(dot(-s, lightDirection[i]))) > lightCutOffAngle[i])
                        sDotN = 0.0;
                }
            }
        }
        else {
            // Directional lights
            // The light direction is in world space already
            s = normalize(-lightDirection[i]);
            sDotN = dot(s, n);
        }

        // Calculate the diffuse factor
        float diffuse = max(sDotN, 0.0);

        // Calculate the specular factor
        if (diffuse > 0.0 && shininess > 0.0) {
            float normFactor = (shininess + 2.0) / 2.0;
            vec3 r = reflect(-s, n);   // Reflection direction in world space
            float specular = normFactor * pow(max(dot(r, v), 0.0), shininess);
            
            specularColor += att * lightIntensity[i] * specular * lightColor[i];
        }

        // Accumulate the diffuse and specular contributions
        diffuseColor += att * lightIntensity[i] * diffuse * lightColor[i];
    }
}
#endif // PT_FEATURE_SHADING

#ifdef PT_FEATURE_SHADOWS
void computeShadow(const in vec3 worldNormal, const in float viewDepth, const in vec4 lightViewportTexCoordDivW, out float shadow) {
    shadow = 1.0;
    
    if (viewDepth < shadowFarPlane) {
        vec3 lightDir = vec3(0.0);
        for (int i = 0; i < lightCount; ++i) {
            if (lightType[i] == TYPE_DIRECTIONAL) {
                lightDir = normalize(-lightDirection[i]);
                break;
            }
        }

        float dt = dot(lightDir, normalize(worldNormal));
        
        if (dt > 0.0) {
            float bias = max(0.0025 * (1.0 - dt), 0.0005);
        
#ifdef PT_PCF_SHADOWS
#ifdef GL_EXT_shadow_samplers 
            shadow = shadow2DProjEXT(shadowMapTexture, lightViewportTexCoordDivW + vec4(0, 0, -bias / lightViewportTexCoordDivW.w, 0));
#else // GL_EXT_shadow_samplers
            shadow = shadow2DProj(shadowMapTexture, lightViewportTexCoordDivW + vec4(0, 0, -bias / lightViewportTexCoordDivW.w, 0)).z;
#endif // GL_EXT_shadow_samplers
#else // PT_PCF_SHADOWS
            float depth = texture2DProj(shadowMapTexture, lightViewportTexCoordDivW + vec4(0, 0, -bias / lightViewportTexCoordDivW.w, 0)).x;
            float R = (lightViewportTexCoordDivW + vec4(0, 0, -bias / lightViewportTexCoordDivW.w, 0)).p / (lightViewportTexCoordDivW + vec4(0, 0, -bias / lightViewportTexCoordDivW.w, 0)).q;
            
            shadow = (R <= depth) ? 1.0 : 0.0;
#endif // PT_PCF_SHADOWS

            float fadeRange = shadowFarPlane * 0.8; 
            if (viewDepth > fadeRange) {
                float shadowFade = (viewDepth - fadeRange) / (shadowFarPlane - fadeRange);                
                shadow = clamp(shadow + shadowFade, 0.0, 1.0);
            }
            
            if (shadow < 1.0) {
                shadow = min(1.0, shadow + (1.0 - shadowIntensity));
            }
        }
    }
}
#endif // PT_FEATURE_SHADOWS

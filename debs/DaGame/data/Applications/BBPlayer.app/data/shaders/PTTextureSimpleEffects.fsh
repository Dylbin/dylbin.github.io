varying vec2 texCoord;

uniform sampler2D texture;

uniform int kernelEffectType; //1 - Sharpen, 2 - Blur
uniform int grayscaleState;
uniform float kernelOffset;
uniform vec2 pixelateAmount;

vec4 applyPostEffects();
vec4 grayscale(vec4 color);

void main() {
    gl_FragColor = grayscale(applyPostEffects());
}

vec4 applyPostEffects() {
    vec4 result = vec4(0.0);
    vec2 tCoord = texCoord;
    
    if (pixelateAmount.x > 0.0) {
        tCoord.x -= mod(tCoord.x, 1.0 / pixelateAmount.x);
    }
    if (pixelateAmount.y > 0.0) {
        tCoord.y -= mod(tCoord.y, 1.0 / pixelateAmount.y);
    }
    
    if (kernelEffectType != 0) {
        float offset = 1.0 / kernelOffset;
        
        vec2 offsets[9];
        offsets[0] = vec2(-offset, offset); //top-left
        offsets[1] = vec2(0.0, offset); //top-center
        offsets[2] = vec2(offset, offset); //top-right
        offsets[3] = vec2(-offset, 0.0); //center-left
        offsets[4] = vec2(0.0, 0.0); //center-center
        offsets[5] = vec2(offset, 0.0); //center-right
        offsets[6] = vec2(-offset, -offset); //bottom-left
        offsets[7] = vec2(0.0, -offset); //bottom-center
        offsets[8] = vec2(offset, -offset); //bottom-right
        
        float kernel[9];
        
        if (kernelEffectType == 1) { //Sharpen
            kernel[0] = -1.0;
            kernel[1] = -1.0;
            kernel[2] = -1.0;
            kernel[3] = -1.0;
            kernel[4] = 9.0;
            kernel[5] = -1.0;
            kernel[6] = -1.0;
            kernel[7] = -1.0;
            kernel[8] = -1.0;
        }
        else if (kernelEffectType == 2) { //Blur
            kernel[0] = 1.0 / 16.0;
            kernel[1] = 2.0 / 16.0;
            kernel[2] = 1.0 / 16.0;
            kernel[3] = 2.0 / 16.0;
            kernel[4] = 4.0 / 16.0;
            kernel[5] = 2.0 / 16.0;
            kernel[6] = 1.0 / 16.0;
            kernel[7] = 2.0 / 16.0;
            kernel[8] = 1.0 / 16.0;
        }
        
        vec4 sampleTex[9];
        for (int i = 0; i < 9; i++) {
            sampleTex[i] = texture2D(texture, tCoord + offsets[i]);
        }
        
        for (int i = 0; i < 9; i++) {
            result += sampleTex[i] * kernel[i];
        }
    }
    else {
        result = texture2D(texture, tCoord);
    }
    
    return result;
}

vec4 grayscale(vec4 color) {
    vec4 result = color;
    
    if (grayscaleState == 1) {
        float average = 0.2126 * result.r + 0.7152 * result.g + 0.0722 * result.b;
        result = vec4(average, average, average, 1.0);
    }
    
    return result;
}

varying vec2 texCoord;

uniform sampler2D texture;

uniform int horizontal;
uniform vec2 pixelSize;
uniform float weights[64];
uniform int passesCount;
uniform vec2 horizontalOffset;
uniform vec2 verticalOffset;

void main() {
    float offset = 0.0;
    
    if (horizontalOffset.x >= 1.0 || horizontalOffset.y >= 1.0 || verticalOffset.x >= 1.0 || verticalOffset.y >= 1.0) {
        offset = 1.0;
    }
    else {
        if (horizontalOffset.x > 0.0 && horizontalOffset.x >= texCoord.x) { //Left
            offset = 1.0 - texCoord.x / horizontalOffset.x;
        }
        else if (horizontalOffset.y > 0.0 && (1.0 - horizontalOffset.y) <= texCoord.x) { //Right
            offset = 1.0 - (1.0 - texCoord.x) / horizontalOffset.y;
        }

        if (verticalOffset.y > 0.0 && verticalOffset.y >= texCoord.y) { //Bottom
            offset = max(1.0 - texCoord.y / verticalOffset.y, offset);
        }
        else if (verticalOffset.x > 0.0 && (1.0 - verticalOffset.x) <= texCoord.y) { //Top
            offset = max(1.0 - (1.0 - texCoord.y) / verticalOffset.x, offset);
        }
        
        if (offset == 0.0) {
            gl_FragColor = texture2D(texture, texCoord);
            return;
        }
    }
    
    vec3 result = texture2D(texture, texCoord).rgb * weights[0];
    
    if (horizontal == 1) {
        for (int i = 1; i < passesCount; ++i) {
            result += texture2D(texture, texCoord + vec2(pixelSize.x * float(i) * offset, 0.0)).rgb * weights[i];
            result += texture2D(texture, texCoord - vec2(pixelSize.x * float(i) * offset, 0.0)).rgb * weights[i];
        }
    }
    else {
        for (int i = 1; i < passesCount; ++i) {
            result += texture2D(texture, texCoord + vec2(0.0, pixelSize.y * float(i) * offset)).rgb * weights[i];
            result += texture2D(texture, texCoord - vec2(0.0, pixelSize.y * float(i) * offset)).rgb * weights[i];
        }
    }
    
    gl_FragColor = vec4(result, 1.0);
}
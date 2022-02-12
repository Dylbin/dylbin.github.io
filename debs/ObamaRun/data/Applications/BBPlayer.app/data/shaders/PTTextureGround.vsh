uniform mat4 worldToLightViewportTexCoord;
uniform vec2 size;
uniform vec4 borderCorners; //left, right, top, bottom
uniform mat4 modelMatrix;
uniform mat4 viewProjectionMatrix;

attribute vec4 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord;

varying vec2 texCoord;
varying vec4 lightViewportTexCoordDivW;
varying vec3 worldPosition;
varying vec3 worldNormal;
varying float viewDepth;

void main() {
    vec4 vertex = a_position;
    vec2 center = vec2(borderCorners.y - borderCorners.x, borderCorners.z - borderCorners.w);
    
    if (size.x == 0.0) {
        if (vertex.x > 0.0) { //Right
            vertex.x = borderCorners.y;
        }
        else { //Left
            vertex.x = borderCorners.x;
        }
        
        texCoord.x = a_texCoord.x * center.x + (borderCorners.y - center.x);
    }
    else {
        vertex.x = vertex.x * size.x;
        texCoord.x = a_texCoord.x * size.x;
    }

    if (size.y == 0.0) {
        if (vertex.z > 0.0) { //Bottom
            vertex.z = borderCorners.w;
        }
        else { //Top
            vertex.z = borderCorners.z;
        }
        
        texCoord.y = 1.0 - (a_texCoord.y * center.y + (borderCorners.z - center.y));
        texCoord.y *= -1.0; //un-mirror the texture
    }
    else {
        vertex.z = vertex.z * size.y;
        texCoord.y = 1.0 - (a_texCoord.y * size.y);
    }
    
    vertex = CC_MVMatrix * vertex;
    
    worldPosition = vertex.xyz;
    worldNormal = (CC_NormalMatrix * a_normal).xyz;
    lightViewportTexCoordDivW = worldToLightViewportTexCoord * vec4(worldPosition, 1.0);
    
    gl_Position = viewProjectionMatrix * vertex;

    viewDepth = gl_Position.z;
}

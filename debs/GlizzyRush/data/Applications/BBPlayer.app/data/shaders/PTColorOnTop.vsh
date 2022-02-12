attribute vec4 a_position;
attribute vec4 a_color;

#ifdef GL_ES
varying lowp vec4 fragmentColor;
#else
varying vec4 fragmentColor;
#endif

void main() {
    fragmentColor = a_color;
    gl_Position = CC_MVPMatrix * a_position;
}

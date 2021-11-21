// Taken from https://www.shadertoy.com/view/XdsGD8

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx = x+sin(t*fx)*sx;
   float yy = y+cos(t*fy)*sy;
   return 1.0/sqrt(xx*xx+yy*yy);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
   vec2 p  = (fragCoord.xy/iResolution.x)*2.0-vec2(1.0,iResolution.y/iResolution.x);
   p       = p*0.5;
   float x = p.x;
   float y = p.y;
   float a = makePoint(x,y,3.3,2.9,0.2,0.1,iTime);
   float b = makePoint(x,y,3.2,3.9,0.3,0.2,iTime);
   float c = makePoint(x,y,3.7,0.3,0.5,0.3,iTime);
   vec3  d = vec3(a,b,c)/32.0;
   fragColor      = vec4(d.x,d.y,d.z,1.0);
   fragColor.rgb -= mod(fragCoord.y,2.0)<1.0 ? 0.5 : 0.0;
}

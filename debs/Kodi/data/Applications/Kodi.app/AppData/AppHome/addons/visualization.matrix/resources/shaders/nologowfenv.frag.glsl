
void main(void)
{
    //general stuff
    vec2 uv = getUV();
    
    //rain
    vec2 gv = floor(uv*cColumns);
    float rnd = h11(gv.x) + 0.1;
    float bw = .965 - fract((gv.y*.0024)+iTime*rnd);
    
    //FFT stuff (visualization)
    float fft = texture(iChannel0, vec2((1.-abs(uv.x))*.7,0.0)).x;
    fft -= abs(uv.x)*.25;
    
    bw *= 1. + fft*0.4*cRainHighlights;
    bw += bw*clamp((pow(fft*1.3*cRainHighlights,2.)-12.),.0,.6);
    bw += bw*clamp((pow(fft*1.0*cRainHighlights,3.)-23.),.0,.7);
    bw = min(bw,1.99);
    
    //waveform
    float wave = texture(iChannel0,vec2(uv.x*.5+.5,0.75)).x*.5;
    //wave -= .5;
    wave = abs(uv.y*wave)*100.;
    bw -= min(.8,wave);
    
    //noise texture
	bw *= noise(gv);

	//vignette effect
	float vignette = length(uv)*cVIGNETTEINTENSITY;
	bw -= vignette;
	
    //pseudo pixels (dots)
    vec3 col = bw2col(bw,uv);

    col *= cINTENSITY;   
    //col.gb = vec2(0.);
    //col.r = wave; 
    
    FragColor = vec4(col,1.0);
}
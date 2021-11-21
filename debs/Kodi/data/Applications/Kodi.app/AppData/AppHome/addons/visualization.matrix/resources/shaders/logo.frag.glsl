void main(void)
{
    //general stuff
    vec2 uv = getUV();
    
    //rain
    vec2 gv = floor(uv*cColumns);
    float rnd = h11(gv.x) + 0.1;
    float bw = 1. - fract((gv.y*.0024)+iTime*rnd);
    
    //VHS-like distortions
    float wav = texture( iChannel0, vec2((uv.y +1.)*.5,1.0) ).x-.5;
	float distort = sign(wav) * max(abs(wav)-cDistortThreshold,.0);
    
    //KODI texture
    float tex = texture(iChannel1, uv+.5-vec2(distort*cDISTORTFACTORX,distort*cDISTORTFACTORY)).x;
    //float tex = texture(iChannel1, uv+.5-vec2(distort,distort)).x;
    //float tex = texture(iChannel1, uv+.5).x;
    tex *= .9 - wav*.2;
    //Shadow effect around the KODI texture. Needs a prepared texture to work.
    float shadow = (wav+.5)*.25;
    tex = (max(shadow,tex)-shadow)/(1.-shadow);
    
    //"interlaced" logo distortion effect
    float line = mod(gv.y*sign(wav),2.);
    float distort_abs = abs(distort);
    tex *= 1. - (line*10.*distort_abs + 5.*distort_abs);
    
    //bw = bw*max(tex,cMININTENSITY);
    bw *= tex*.7 + .1;
    
    //brightens lines where distortion are occuring
	//bw += min(distort_abs*.7,.0105);
	bw += distort_abs*.2;
    
    //FFT stuff (visualization)
    //might need some scaling
    float fft = texture( iChannel0, vec2((1.-abs(uv.x-distort*.2))*.7,0.0) ).x;
    fft *= (3.2 -abs(0.-uv.x*1.3))*0.75;
    fft *= 1.8;
    
    bw=bw+bw*fft*0.4*cRainHighlights;
    bw += bw*clamp((pow(fft*1.3*cRainHighlights,2.)-12.),.0,.6);
    bw += bw*clamp((pow(fft*1.0*cRainHighlights,3.)-23.),.0,.7);
    //bw = min(bw,1.99);
    
    //noise texture
	bw *= noise(gv);

	//vignette effect
	float vignette = length(uv)*cVIGNETTEINTENSITY;
	bw -= vignette;
	
    //pseudo pixels (dots)
    vec3 col = bw2col(bw,uv);
    
    //col *= cINTENSITY;
    
    FragColor = vec4(col,1.0);
}
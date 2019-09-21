#ifdef GL_ES
precision mediump float;
#endif

//#extension GL_OES_standard_derivatives : enable
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PIE = 3.141592;

vec3 circle(float r,vec2 pos,vec2 p){
	float dis = distance(pos,p);
	float a = 0.00;
	a += 0.01/pow(dis,1.2);
	return vec3(a,a,0.);
}

vec3 circle2(float r,vec2 pos,vec2 p){
	float dis = distance(pos,p);
	float a = 0.00;
	a += 0.008/pow(dis,1.2);
	return vec3(0.,a,a);
}

vec3 circle3(float r,vec2 pos,vec2 p){
	float dis = distance(pos,p);
	float a = 0.00;
	a += 0.008/pow(dis,1.2);
	return vec3(a,0.,a);
}


void main( void ) {
	vec3 color = vec3(0.0,0.0,0.0);
	float ratio = resolution.x/resolution.y;
	
	float r = 0.4;
	vec2 between = vec2(r,r);
	
	vec2 position = ( gl_FragCoord.xy / resolution.y );
	
	for(float i = 0.0;i<6.0;i++){
		float ii = i* PIE/3.;
		vec2 p = vec2(sin(ii/2.+time),cos(ii+time))*(0.4+cos(time)*0.1) + vec2(0.5*ratio,0.5);
		color += circle(r,position,p) * 0.8;
		p = vec2(sin(i+time+0.5),cos(ii/2.+time+0.5))*0.8*cos(time) + vec2(0.5*ratio,0.5);
		color += circle2(r,position,p);
		p = vec2(sin(i+time+0.5),cos(ii/5.+time+0.5))*0.8*cos(time) + vec2(0.5*ratio,0.5);
		color += circle3(r,position,p);
	}
	gl_FragColor = vec4( color, 1.0 );
}
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(){
    float ratio = resolution.x/resolution.y;
    vec2 position = (gl_FragCoord.xy / resolution.y);
    float point = 0.5;
    vec2 p = vec2(point*ratio,point);
    vec3 white = vec3(1.0,1.0,1.0);
    vec3 l_blue = vec3(0.0,1.0,1.);
    vec3 purple = vec3(1.,0.,1.);
    vec3 yellow = vec3(1.,1.,0.);
    vec3 color = vec3(0.,0.,0.);
    
    float l = distance(position,p)*5.*(abs(sin(time*9.5))+1.);
    color = l_blue*fract(pow(l,1.5));

    p = (gl_FragCoord.xy*2.0-resolution)/min(resolution.x,resolution.y);
    float a = mix(p.x*p.x,p.y,sin(time));
    l = 0.3/length(p+a);
    color += purple*l;

    float loop = 100.0;
    float length = 3.0;
    for(float i = 0.0; i<loop; i++){
        p = vec2(point*ratio,point) + vec2(cos((time-length*i/loop)*1.5+2.),sin(time-length*i/loop))*0.4;
        l = distance(position,p);
        color += (1.-i/loop)*purple /(l*loop*5.);
    }
    

    gl_FragColor = vec4(color,0.);
}
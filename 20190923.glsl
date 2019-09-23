#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float random(in vec2 p){
    return fract(sin(dot(p.xy,vec2(10.,12.))) * 100000.);
}

float noise(in vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.,0.));
    float c = random(i + vec2(0.,1.));
    float d = random(i + vec2(1.,1.));
    vec2 u = f * f  * (3. - 2. *f);
    return mix(a,b,u.x) + (c - a)* u.y * (1.0-u.x)+(d-b)*u.x * u.y;
}

#define OCTAVES 4
float fbm(in vec2 p){
    float value = 0.;
    float amplitud = 0.1;
    float frequency = 0.;
    for(int i=0; i < OCTAVES;i++){
        value += amplitud * noise(p);
        p *=2.;
        amplitud *=0.8;
    }
    return value;
}

//湧き出る感じを実装
float dSpring(vec3 p){
    vec3 n = normalize(vec3(0.,1.,0.));
    float gush = fbm(vec2(p.x,length(p*2.5) - time*3.)*0.15);

    return dot(p,n) + gush;
}


//法線取得
vec3 genNormal(vec3 p){
    float d = 0.001;
    return normalize(vec3(
        dSpring(p + vec3(d,0.,0.)) - dSpring(p + vec3(-d,0.,0.)),
        dSpring(p + vec3(0.,d,0.)) - dSpring(p + vec3(0.,-d,0.)),
        dSpring(p + vec3(0.,0.,d)) - dSpring(p + vec3(0.,0.,-d))
    ));
}

void main(){
    vec3 spring = vec3(0.9,0.9,0.6);

    //colorの初期化
    vec3 color = vec3(0.);

    //座標の正規化
    vec2 p = (gl_FragCoord.xy*2. - resolution.xy)/min(resolution.x,resolution.y);

    //カメラ設定
    vec3 cPos = vec3(0.,0.,2.);//カメラ位置
    vec3 cDir = vec3(0.,0.,-1.);//カメラ方向
    vec3 cUp = vec3(0.,1.,0.);//カメラ上方向
    vec3 cSide = cross(cDir,cUp);//外積で横方向を計算
    float targetDepth = 1.;//深度

    //Ray生成
    vec3 ray = normalize(cSide*p.x + cUp*p.y + cDir*targetDepth);

    //レイマーチングループ
    float dist = 0.;//レイと穴の距離
    float rLen = 0.;//レイの長さ
    vec3 rPos = cPos;//レイの先端
    for(int i = 0; i < 32; i++){
        dist = dSpring(rPos);//rPos(最初は先端)の長さ-1,ここでの1で穴の大きさを調整
        rLen += dist;//dist分だけrLenを伸ばす
        rPos = cPos + ray * rLen;//rPosはcPosからrLenだけ離れた場所
    }

    //衝突判定
    if(abs(dist) < 0.001){
        vec3 normal = genNormal(rPos); //物体の法線情報
        vec3 light = normalize(vec3(sin(time),1.2,0.));//ライト位置
        float diff = max(dot(normal,light),0.1);//拡散反射光を内積で算出

        vec3 eye = reflect(normalize(rPos - cPos),normal);
        float speculer = pow(clamp(dot(eye,light),0.,1.) * 1.0225,30.);

        color = (spring + speculer) * diff;
    }else{
        color = vec3(0.);
    }

    gl_FragColor = vec4(color,1.0);
}
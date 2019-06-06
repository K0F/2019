
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float time = 0.0;
const float pi = 3.14159265;

void main(){
  float X = 1920/2.0-gl_FragCoord.x;
  float Y = 1080/2.0-gl_FragCoord.y;
  float d = sqrt(X*X+Y*Y)/10.0+1.0*(sin(atan(X/1080.0,Y/1920.0)*pi*2.0/10.0+time/25.0)*100.0);
  float r = 0.5*(sin(time/205.1*d*pi)+1.0);
  float g = 0.5*(sin(time/205.1*d*pi)+1.0);
  float b = 0.5*(sin(time/205.1*d*pi)+1.0);
  gl_FragColor = vec4(r,g,b,1.0);
}

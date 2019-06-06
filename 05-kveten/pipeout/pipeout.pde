
//import processing.opengl.*;
import java.io.RandomAccessFile;

RandomAccessFile pipe;
byte raw[];

String tc;
PShader glsl;
int rate = 25;



void setup() {
  size(1920, 1080, P2D);
  smooth();

  raw = new byte[width*height*3];
  try {
    Process b = new ProcessBuilder( "rm" , sketchPath("")+"/raw.rgb" ).start();
    b.waitFor();
    pipe = new RandomAccessFile( sketchPath("")+"/raw.rgb" , "rw" );
  }
  catch(Exception e) {
    println("error opening pipe: "+e);
  }

  textFont(createFont("Dialog.bold",12,false));
  textAlign(CENTER);

  frameRate(rate);
  rectMode(CENTER);

  for(int i = 0 ; i < width;i++){
    stroke( map(i, 0,width,0,255) );
      line(i,0,i,height);
  }
  fill(0);
  noStroke();

  glsl = loadShader("one.glsl");

}

void keyPressed(){
  if(key==' '){
  glsl = loadShader("one.glsl");
  }

}

int X[]={0,0,0,0,0,0,3,7,19,13,-7,-100,100};
int Y[]={0,0,0,0,3,1,1,1,1,1,0,0,0,17,4,100,-100};



void draw() {
  //background(0);

 glsl.set("time",frameCount+0.0);
 filter(glsl);
  drawTc();
  dump();

}

int c=0;

void dump(){
  loadPixels();
  for (int i = 0 ; i < pixels.length;i++) {
    raw[i*3]= (byte)(pixels[i] >> 16 & 0xFF);
    raw[i*3+1]= (byte)(pixels[i] >> 8 & 0xFF);
    raw[i*3+2]= (byte)(pixels[i] & 0xFF);
  }
  try {
    pipe.write(raw);
  }
  catch (Exception e) {
    e.printStackTrace();
  }

}

int frames,seconds,minutes,hours;
void drawTc(){

  frames++;

  if(frames>rate-1){
    frames=0;
    seconds++;
  }

  if(seconds>59){
   seconds=0;
   minutes++;
   }

  if(hours>23){
   hours=0;
  }


  tc = nf(hours,2)+":"+nf(minutes,2)+":"+nf(seconds,2)+":"+nf(frames,2);
  fill(0);
  noStroke();
  rect(width/2,35,90,20);
  fill(255);
  text(tc,width/2,40);

}

void exit() {
  try {
    pipe.close();
  }
  catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
  super.exit();
}

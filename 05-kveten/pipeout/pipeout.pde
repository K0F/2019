
//import processing.opengl.*;
import java.io.RandomAccessFile;

RandomAccessFile pipe; 
byte raw[];

String tc;

void setup() {
  size(720, 576, P2D);
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
  frameRate(60);
  rectMode(CENTER);
  
  for(int i = 0 ; i < width;i++){
    stroke( map(i, 0,width,0,255) );
      line(i,0,i,height); 
  }
  fill(0);
  noStroke();
 
}

int X[]={0,0,0,0,0,0,3,7,19,13,-7,-100,100};
int Y[]={0,0,0,0,3,1,1,1,1,1,0,0,0,17,4,100,-100};



void draw() {
  //background(0);
  
  imageMode(CENTER);
  pushMatrix();
  translate(width/2,height/2);
  //rotate(radians(-0.001));
  image(g,0,1);
  popMatrix();
  
   ellipse(
   width/2+cos(frameCount/250.0*TWO_PI)*150.0,
   height/2+sin(frameCount/250.0*TWO_PI)*150.0
   ,height/3.0,height/3.0);
  noStroke();
  fill((sin(frameCount/600.0)+1.0)*127.0,75);
  
  dump();

}

int c=0;

void dump(){
  loadPixels();
  for (int i = 0 ; i < pixels.length;i++) {
    raw[i*3]= (byte)(pixels[i] >> 16 & 0XFF);
    raw[i*3+1]= (byte)(pixels[i] >> 8 & 0XFF);
    raw[i*3+2]= (byte)(pixels[i] & 0XFF);
  }
  try {
    pipe.write(raw);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

}

void exit() {
  try {
    pipe.close();
  }
  catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

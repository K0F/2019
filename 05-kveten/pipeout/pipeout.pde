
//import processing.opengl.*;
RandomAccessFile pipe; 
byte raw[];

String tc;

void setup() {
  size(720, 576, P2D);
  smooth();
  raw = new byte[width*height*3];
  try {
    Process b = new ProcessBuilder( "rm" , sketchPath+"/raw.rgb" ).start();
    b.waitFor();
    pipe = new RandomAccessFile( sketchPath + "/raw.rgb" , "rw" );
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
  //image(g,1,0);
   ellipse(
   width/2+cos(frameCount/250.0*TWO_PI)*3.0,
   height/2+sin(frameCount/250.0*TWO_PI)*3.0
   ,576/1.33,576/1.33);
  noStroke();
  fill(255,50);

  loadPixels();
  
  for(int i = 0 ; i < pixels.length;i++){
   int x = i%width;
   int y = i/width;
   x+=(X[(frameCount+i)%X.length]+width);
   y+=(Y[(frameCount+i)%Y.length]+height);
   x=(x+width)%width;
   y=(y+height)%height;
      
   pixels[i] += (65535-pixels[y*width+x]-pixels[i])/65535.0*sin(frameCount/2500.0*TWO_PI); 
  }
  
  /*
  X=expand(X,X.length+1);
  X[X.length-1]=(int)random(-10,10);
*/
  updatePixels();
  
  //filter(INVERT);
  //image(g,0,0);
  //filter(GRAY);
  //blend(g,0,0,width,height,0,0,width-1,height-1,frameCount%16);
  
  if(frameCount%5==0){
  c++;
  }
  blend(g,0,0,width,height,0,0,width-1,height-1,c%14);
  filter(BLUR);
//  }
 
  
  filter(GRAY);
  
  dump();

}

int c=0;

void dump(){
  
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


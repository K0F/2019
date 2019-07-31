
//import processing.opengl.*;
import java.io.RandomAccessFile;

RandomAccessFile pipe;
byte raw[];
int rate = 25;
String tc;
PShader glsl;
int rate = 25;



void setup() {
<<<<<<< HEAD
  size(720, 576);
=======
  size(1920, 1080, P2D);
>>>>>>> cb706611b8a58b5bc28aadae5209cda4102926e7
  smooth();

  raw = new byte[width*height*3];

  try {
    Process b = new ProcessBuilder( "rm", sketchPath("")+"/raw.rgb" ).start();
    b.waitFor();
    pipe = new RandomAccessFile( sketchPath("")+"/raw.rgb", "rwd" );
  }
  catch(Exception e) {
    println("error opening pipe: "+e);
  }
<<<<<<< HEAD
  frameRate(rate);
  rectMode(CENTER);

  fill(255);
  noStroke();
  
  background(0);
  ellipse(width/2, height/2, 350, 350);
  
  textFont(loadFont("Dialog.bold-12.vlw"));
  textAlign(CENTER);

X=new int[0];
Y=new int[0];

  for(int i = 0 ;i < 1000;i++){
   X=expand(X,X.length+1);
  X[X.length-1]=(int)(noise(i/1000.0,0)*256-128)/64; 
   Y=expand(X,X.length+1);
  Y[Y.length-1]=(int)(noise(0,i/1000.0)*256-128)/64;
  }
=======

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

>>>>>>> cb706611b8a58b5bc28aadae5209cda4102926e7
}
int cnt =0 ;

int X[],Y[];


void draw() {
<<<<<<< HEAD
 
 
  loadPixels();
  cnt++;

  for (int i = 0 ; i < pixels.length ; i++) {
    int x = i % width;
    int y = i / width;
    int xx = (x+X[(cnt+x)%X.length]+width-1) % width;
    int yy = (y+Y[(cnt+y)%Y.length]+height-1) % height;

    pixels[i] += color( brightness(pixels[i]) - brightness(pixels[yy*width+xx]) );
    pixels[i] += (int)random(-1,1);
  }
  updatePixels();
  
  
 // tint(255,5);
//  image(g,4,4,width-8,height-8);
 // filter(DILATE);
  //filter(BLUR);
  
  //fill(0,5);
  //ellipse(width/2, height/2, 350, 350);
  
  
  drawTc();
   
=======
  //background(0);

 glsl.set("time",frameCount+0.0);
 filter(glsl);
  drawTc();
>>>>>>> cb706611b8a58b5bc28aadae5209cda4102926e7
  dump();
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
  
  if(minutes>59){
   minutes=0;
   hours++; 
  }
  
  if(hours>23){
   hours=0; 
  }
  
  
  tc = nf(hours,2)+":"+nf(minutes,2)+":"+nf(seconds,2)+":"+nf(frames,2);
  fill(0);
  noStroke();
  rect(width/2,35,80,20);
  fill(255);
  text(tc,width/2,40);
  
}

int c=0;

void dump() {
  loadPixels();
  for (int i = 0 ; i < pixels.length;i++) {
<<<<<<< HEAD
    raw[i*3] = (byte)(pixels[i] >> 16 & 0XFF);
    raw[i*3+1] = (byte)(pixels[i] >> 8 & 0XFF);
    raw[i*3+2] = (byte)(pixels[i] & 0XFF);
=======
    raw[i*3]= (byte)(pixels[i] >> 16 & 0xFF);
    raw[i*3+1]= (byte)(pixels[i] >> 8 & 0xFF);
    raw[i*3+2]= (byte)(pixels[i] & 0xFF);
>>>>>>> cb706611b8a58b5bc28aadae5209cda4102926e7
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


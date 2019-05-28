
//import processing.opengl.*;
RandomAccessFile pipe; 
byte raw[];

String tc;

void setup() {
  size(720, 576, P2D);
  smooth();
  raw = new byte[width*height*3];
  try {
    Process b = new ProcessBuilder("rm", sketchPath+"/pipe").start();
    b.waitFor();
    pipe = new RandomAccessFile(sketchPath+"/pipe", "rw");
  }
  catch(Exception e) {
    println("error opening pipe: "+e);
  }
  frameRate(60);
  rectMode(CENTER);
}

void draw() {
  background(0);
  noStroke();
  fill(255,50);

  for (int i = 0 ; i < 240;i++) {
    float theta = sin(frameCount/25.0*TWO_PI*((120.0+i/120.0)/120.0));
    //fill(i%2==0?0:255, 100);
    rect(width/2+theta*width/2, height/2, 10, height);
  }

  loadPixels();
  for (int i = 0 ; i < pixels.length;i++) {
    raw[i*3]= (byte)(pixels[i] >> 16 & 0XFF);
    raw[i*3+1]= (byte)(pixels[i] >> 8 & 0XFF);
    raw[i*3+2]= (byte)(pixels[i] & 0XFF);
  }
//  updatePixels();
  //println(frameCount);

//  filter(BLUR,2);

  try {
    // Connect to the pipe
    // write to pipe
    pipe.write ( raw );
    // read response
    //String echoResponse = pipe.readLine();
    //System.out.println("Response: " + echoResponse );
  } 
  catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }


  //dos.close();

  //saveBytes("pipe", raw);
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




import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

OscThread osc;

String [] names = {"/a","/b","/c","/d","/e","/f","/g","/h"};
int size = 64;
int tracks = 8;
float grid[][];
int sel = 0;
float speed = 8.0;
double bpm = 120.0;

ArrayList editors;
Editor editor;


void setup() {
  size(1366,720);
  saveStrings("fonts.txt",PFont.list());
  textFont(createFont("Monaco for Powerline",9,false));
  // create new thread running at 160bpm, bit of D'n'B

  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",10000);
  grid = new float[tracks][size];

  osc=new OscThread(bpm);
  osc.start();

  editor = new Editor("/a",0);

  editors = new ArrayList();
  editors.add(editor);

}

// sequencer offsets
int sx = 270;
int sy = 10;

float tt;

void draw() {
  background(25);

  fill(osc.clock_led);
  stroke(255);
  rect(width-15,10,5,5);
  tt = pow((sin((float)osc.total/1000.0*((float)bpm/60.0)*TWO_PI+HALF_PI)+1)/2.0,3)*255;
  fill(tt);
  rect(width-25,10,5,5);
  // sequencer
  pushMatrix();
  translate(sx,sy);


  fill(255);
  text("OSC out:",width-56,16);
  text("BPM: "+bpm,16,16);
  fill(250);
  rect(sel*12+18,28,14,grid.length*12+2);
  for(int ii = 0; ii < tracks;ii++){
    fill(255);
    text(names[ii],5,ii*12+39);
    for(int i = 0 ; i < size;i++){
      fill(grid[ii][i]*255);
      stroke(i%4==0?color(255,128,0,200):color(255,200));
      rect(i*12+20,ii*12+30,10,10);
    }
  }

  popMatrix();

  editor.draw();

  if(osc.clock_led>0)
    osc.clock_led-=40;
}

class Editor{
  ArrayList text;
  int tab = 0;
  int carret;
  int ln;
  String name;
  int id;

  Editor(String _name,int _id){
    id = _id;
    name = ""+_name;
    text=new ArrayList();
    String raw[] = split("(\nSynth(\\a,{\n   var sig = SinOsc.ar(220);\n  };\n).add();\n)",'\n');
    for(int i = 0; i < raw.length;i++){
      text.add(new String(raw[ i ]));
    }
  }

  void draw(){
    stroke(255);
    fill(35);

    textAlign(CENTER);
    int w = 25;
    rect(30,180,width-60,500);
    rect(30+id*w,180,w,-12);
    fill(255);
    text(name,30+id*w+w/2,178);
    textAlign(LEFT);

    for(int i = 0 ; i < text.size();i++){
      String curText = (String)text.get(i);
    fill(255);
    text(curText, 40, 196 + ( i * 12 ) );
    if(i==ln){
noStroke();
      fill(255,tt);
      rect(textWidth( curText.substring(0,carret) ) + 40, 196 + (ln*12) + 3, 2 ,-12 );
    }
    }
  }

}

void mouseClicked(){
  for(int ii = 0; ii < tracks;ii++){
    for(int i = 0 ; i < size;i++){
      if(mouseX>i*12+20+sx&&mouseX<i*12+20+10+sx&&mouseY>ii*12+30+sy&&mouseY<ii*12+30+10+sy){
        grid[ii][i] = grid[ii][i]==1?0:1;
      }
    }
  }
}

// also shutdown the osc thread when the applet is stopped
public void stop() {
  if (osc!=null) osc.isActive=false;
  super.stop();
}

void keyPressed(){
  /*
  if(key == ' ')
    reset();
*/
  if(key =='=')
    bpm++;

  if(key =='-')
    bpm--;

  if(keyCode==DELETE){
    for(int ii = 0; ii < grid.length;ii++)
      for(int i = 0; i < grid[ii].length;i++)
        grid[ii][i] = 0;
  }

/*
  if(keyCode==TAB){
    String current = (String)editor.text.get(editor.ln);
    current = current.substring(0,editor.carret) + "  " + current.substring(editor.carret,((String)editor.text.get(editor.ln)).length());
    editor.text.set(editor.ln,current);
    editor.carret++;

  }
*/

  if(keyCode==LEFT){
editor.carret--;
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());

  }

  if(keyCode==RIGHT){
editor.carret++;
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());

  }

  if(keyCode==UP){
    editor.ln--;
    editor.ln=constrain(editor.ln,0,editor.text.size()-1);
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());
  }

  if(keyCode==DOWN){
    editor.ln++;
    editor.ln=constrain(editor.ln,0,editor.text.size()-1);
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());
  }

  if(keyCode==BACKSPACE){

    String current = (String)editor.text.get(editor.ln);

    if(editor.ln > 0 && editor.carret==0){
      editor.carret=((String)editor.text.get(editor.ln-1)).length();

      editor.text.set(editor.ln-1,((String)editor.text.get(editor.ln-1))+""+current);
      editor.text.remove(editor.ln);
      editor.ln--;

    }else if(editor.carret>0){
    current = current.substring(0,editor.carret-1)+current.substring(editor.carret,((String)editor.text.get(editor.ln)).length());
    editor.text.set(editor.ln,current);

    editor.carret--;
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());
      }



  }

//broken
  if(keyCode==ENTER){
    String current = (String)editor.text.get(editor.ln);
    editor.text.set(editor.ln,current.substring(0,editor.carret));

    editor.text.add(editor.ln+1,current.substring(editor.carret,current.length()) );
editor.ln++;
        editor.carret=0;
  }

  if(keyCode==DELETE){

    String current = (String)editor.text.get(editor.ln);

    // line break
    if(editor.carret==current.length() && editor.ln < editor.text.size()-1){
      editor.text.set(editor.ln,(String)editor.text.get(editor.ln)+(String)editor.text.get(editor.ln+1));
      editor.text.remove(editor.ln+1);
    }else{
      current = current.substring(0,editor.carret)+current.substring(editor.carret+1,((String)editor.text.get(editor.ln)).length());
      editor.text.set(editor.ln,current);
    }
    //editor.carret--;
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());

  }else if(key>= 13 && key <= 127){
    String current = (String)editor.text.get(editor.ln);
    current = current.substring(0,editor.carret) + key + current.substring(editor.carret,((String)editor.text.get(editor.ln)).length());
    editor.text.set(editor.ln,current);
    editor.carret++;
  }

}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());

  if(theOscMessage.addrPattern().equals("/reset"))
    reset();

  if(theOscMessage.addrPattern().equals("/bpm"))
    bpm = (double)theOscMessage.get(0).floatValue();

}

void reset(){

  osc.previousTime=System.nanoTime();
  osc.total = 0;
  sel=0;
}

class OscThread extends Thread {
  float clock_led = 0;
  long previousTime;
  boolean isActive=true;
  double interval;
  double total;

  OscThread(double _bpm) {
    bpm = _bpm;
    // interval currently hard coded to quarter beats
    interval = 1000.0 / (bpm / 60.0 * speed);
    previousTime=System.nanoTime();
  }

  void run() {
    try {
      while(isActive) {
        // calculate time difference since last beat & wait if necessary
        interval = 1000.0 / (bpm / 60.0 * speed);
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }

        for(int ii = 0; ii < tracks;ii++){
          if(grid[ii][sel]>0){
            clock_led = 255;
            OscMessage myMessage = new OscMessage(names[ii]);
            myMessage.add(grid[ii][sel]);
            oscP5.send(myMessage, myRemoteLocation);
            println("OSC "+names[ii]+" "+grid[ii][sel]+" time: "+total+"ms");
          }
        }

        total+=timePassed;
        sel++;
        if(sel>=size)
          sel=0;

        // insert your osc event sending code here
        // calculate real time until next beat
        long delay=(long)(interval-(System.nanoTime()-previousTime)*1.0e-6);
        previousTime=System.nanoTime();
        if(delay>0)
          Thread.sleep(delay);

      }
    }
    catch(InterruptedException e) {
      println("force quit...");
    }
  }
}

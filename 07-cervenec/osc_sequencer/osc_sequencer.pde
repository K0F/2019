
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress sc;

OscThread osc;

String [] names = {"a","b","c","d","e","f","g","h"};
int size = 16;
int tracks = 8;
float grid[][];
int sel = 0;
float speed = 8.0;
double bpm = 120.0;
int tab = 0;

ArrayList editors;
Editor editor;


void setup() {
  size(800,720);
  // saveStrings("fonts.txt",PFont.list());
  textFont(createFont("Semplice Regular",8,false));

  oscP5 = new OscP5(this,12000);
  sc = new NetAddress("127.0.0.1",57120);
  grid = new float[tracks][size];

  osc=new OscThread(bpm);
  osc.start();

  editors = new ArrayList();

  for(int i = 0; i < names.length;i++){
    editors.add(new Editor(names[i],i));
  }

  editor = (Editor)editors.get(tab);

}

////////////////////////////////////////////////////


void msg(String obj,String key,float val){
  oscP5.send("/oo",new Object[] {obj,"set",key,val},sc);
}

void execute(String data){
  oscP5.send("/oo_i",new Object[]{data},sc);
}

void freeAll(){
  oscP5.send("/oo_i",new Object[]{"s.freeAll;"},sc);
}

void stop(){
  //saveProject("default.txt");
  freeAll();
  if (osc!=null) osc.isActive=false;
  super.stop();
}

///



// sequencer offsets
int sx = 10;
int sy = 10;

float tt;

void draw() {
  background(25);

  fill(osc.clock_led);
  stroke(255);
  rect(width-15,10,5,5);
  tt = pow((cos((float)osc.total/1000.0*((float)bpm/60.0)*TWO_PI-HALF_PI)+1)/2.0,3)*255;
  fill(tt);
  rect(width-25,10,5,5);
  // sequencer
  pushMatrix();
  translate(sx,sy);


  fill(255);
  text("OSC out:",width-56,16);
  text("BPM: "+bpm,16,16);
  fill(250);
  pushMatrix();
  translate(width/2,100);
  
  //rect(sel*12+18,28,14,grid.length*12+2);
  
  float ss = map(sel,0,grid.length,0,TWO_PI);

  for(int ii = 0; ii < tracks;ii++){
    //fill(255);
    //text(names[ii],5,ii*12+39);

    for(int i = 0 ; i < size;i++){
      pushMatrix();
      rotate(map(i,0,size,0,TWO_PI));
      //rect(0,ii*12+30,10,10);
      noFill();
      //stroke(i%4==0?color(255,128,0,200):color(255,200));
      stroke(grid[ii][i]*255);
      strokeWeight(9);
      strokeCap(SQUARE);

      arc(0, 0, ii*20+40, ii*20+40, 0, TWO_PI/size);
      
      strokeWeight(1);
      popMatrix();
    }

  }
  popMatrix();

  popMatrix();

  fill(35);
  rect(30,180,width-60,500);

  editor = (Editor)editors.get(tab);


  for(int i = 0 ; i < editors.size();i++){
    Editor tmp = (Editor)editors.get(i);
    tmp.draw();
  }

  if(osc.clock_led>0)
    osc.clock_led-=40;
}

class Editor{
  ArrayList text;
  int carret;
  int ln;
  String name;
  int id;
  boolean bang = false;
  int fade = 0;

  Editor(String _name,int _id){
    id = _id;
    name = ""+_name;

    setText("(\nSynthDef('"+name+"',{|sus=1.0|\n   var env = EnvGen.ar(Env.new([0,1,0],[0.02,sus]),doneAction:2);\n    var sig = SinOsc.ar(50,env*2pi);\n sig = sig * env; \n Out.ar(0,sig); }\n).add();\n)");

    execute(getText());
  }

  String getText(){

    String tmp = "";
    for(int i =0 ; i < text.size();i++){
      String line = (String)text.get(i);
      tmp+=line;
    }
    return tmp;
  }

  void setText(String _text){
    String raw[] = split(_text,'\n');
    text=new ArrayList();

    for(int i = 0; i < raw.length;i++){
      text.add(new String(raw[i]));
    }
  }

  void draw(){
    stroke(255);


    textAlign(CENTER);
    int w = 25;

    if(bang){
      fade=255;
      bang = false;
    }

    fill(tab==id?150:25);
    rect(30+id*w,180,w,-12);

    noStroke();
    fill(#ffcc00,fade);
    if(fade>0)fade-=10;
    rect(30+id*w,180,w,-12);

    fill(255);
    text(name,30+id*w+w/2,178);
    textAlign(LEFT);
    if(id==tab){
      pushMatrix();

      //translate(id*180,0);

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
      popMatrix();

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


boolean controlDown = false;


void keyReleased(){
  if(key==CODED){
    if(keyCode==SHIFT)
      controlDown=false;
  }
}

void keyPressed(){
  // println(keyCode);

  if(keyCode==CONTROL){
    controlDown = true;
  }

  if(keyCode == 155)
    reset();

  if(key =='=')
    bpm++;

  if(key =='-')
    bpm--;

  if(keyCode==DELETE){
    for(int ii = 0; ii < grid.length;ii++)
      for(int i = 0; i < grid[ii].length;i++)
        grid[ii][i] = 0;
  }

  if(keyCode==9){
    tab++;
    if(tab>=editors.size())
      tab=0;
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

    if(editor.carret==0 && editor.ln > 0){
      editor.carret=((String)editor.text.get(editor.ln-1)).length();
      editor.ln--;
    }else{
      editor.carret--;
    }
    editor.carret=constrain(editor.carret,0,((String)editor.text.get(editor.ln)).length());
    editor.ln=constrain(editor.ln,0,editor.text.size()-1);

  }

  if(keyCode==RIGHT){

    if(editor.carret >= ((String)editor.text.get(editor.ln)).length() && editor.ln < editor.text.size()){
      editor.carret=0;
      editor.ln++;
    }else{
      editor.carret++;
    }
    editor.ln=constrain(editor.ln,0,editor.text.size()-1);
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

  println(keyCode);
  //F5
  if(keyCode==116){
    String tmp = editor.getText();
    execute(tmp);
    keyPressed = false;
  }

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
            //OscMessage myMessage = new OscMessage(names[ii]);
            //myMessage.add(grid[ii][sel]);
            //oscP5.send(myMessage, sc);
            execute( "Synth.new('"+names[ii]+"');" );
            println("OSC /"+names[ii]+" "+grid[ii][sel]+" time: "+total+"ms");
            Editor e = (Editor)editors.get(ii);
            e.bang = true;
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

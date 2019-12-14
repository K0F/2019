/*
  the ways of resoring a certain states are always bit tricky
  this tool has no proper use
  it is basicly children (human) toy there is no known way how to breake it
  enjoy doing whatever useful with it
*/

int num = 4;
ArrayList discs;
int x [] = {80,80,80,80};
int y [] = {80,160,240,320};

void setup(){
  size(160,480,P2D);
  discs = new ArrayList();

  for(int i = 0 ;i < num;i++)
    discs.add(new Disc(i,x[i],y[i]));

}

void draw(){
  background(0);

  for(int i = 0 ; i < discs.size();i++){
    Disc tmp = (Disc)discs.get(i);
    tmp.draw();
  }

}

class Disc{
  String bits;
  float velikost = 15;
  boolean rotating = false;
  int id;
  PVector pos;
  float rot;
  float rotT = 1.0;

  Disc(int _id,int _x,int _y){
    id = _id;
    bits = new String("0001");
    pos = new PVector(_x,_y);
    rot = 0 ;
  }

  void draw(){
    rot += (rotT-rot)/(15.00/4.0);
    if(rotating){
      if(abs(rot-rotT)<0.001){
        rotating = false;
    interpret();
        rot = rotT = 0;

      }
    }

    pushMatrix();
    translate(pos.x,pos.y);
    rotate(rot*HALF_PI);
    stroke(255,200);
    line(-velikost,0,velikost,0);
    line(0,-velikost,0,velikost);
    pushMatrix();
    for(int i = 0 ; i < bits.length();i++){
      if((bits.charAt(i)+"").equals("1")){
        fill(255);
        noStroke();
        arc(0,0,2*velikost,2*velikost,0,HALF_PI);
      }
        rotate(HALF_PI);
    }
    popMatrix();

    popMatrix();
    if(over()&&!rotating&&mousePressed){
      rotating = true;
      rotT+=1.0;
      
    }else if(over()){
      noStroke();
      fill(255,120);
      ellipse(pos.x,pos.y,2*velikost,2*velikost);
    }
  }

  boolean over(){

    float d = dist(pos.x,pos.y,mouseX,mouseY);
    if(d<velikost*2){
      return true;
    }else{
      return false;
    }

  }

  String rotateM(int ammount){
    String tmp = "";
    for(int i = 0 ; i < bits.length();i++){
      tmp += bits.charAt((i+bits.length()+ammount)%bits.length());
    }
    return tmp;
  }

  void interpret(){
    bits = rotateM(round(rot));
  }

}

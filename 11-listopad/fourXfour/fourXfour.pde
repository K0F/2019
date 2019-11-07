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
    rot += (rotT-rot)/3.98;
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(rot*HALF_PI);
    stroke(255,200);
    line(-10,0,10,0);
    line(0,-10,0,10);
    pushMatrix();
    for(int i = 0 ; i < bits.length();i++){
      if((bits.charAt(i)+"").equals("1")){
        fill(255);
        noStroke();
        arc(0,0,20,20,0,HALF_PI);
      }
        rotate(HALF_PI);
    }
    popMatrix();

    popMatrix();
    if(over()){
      noStroke();
      fill(255,120);
      ellipse(pos.x,pos.y,20,20);
    }
  }

  boolean over(){

    float d = dist(pos.x,pos.y,mouseX,mouseY);
    if(d<15){
      return true;
    }else{
      return false;
    }

  }

  String rotateL(){
    String tmp = "";
    for(int i = 0 ; i < bits.length();i++){
      tmp += bits.charAt((i+bits.length()-1)%bits.length());
    }
    return tmp;
  }

  String rotateR(){
    String tmp = "";
    for(int i = 0 ; i < bits.length();i++){
      tmp += bits.charAt((i+1)%bits.length());
    }
    return tmp;
  }


  int interpret(){
    return unbinary(bits);
  }

}

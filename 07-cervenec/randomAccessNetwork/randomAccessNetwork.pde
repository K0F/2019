
int b = 100;
int step = 10;
int numC = 4;
int area = 35;
float slowdown = 2000.0;

boolean move = false;

ArrayList nodes;


ArrayList energy;

float scatter = 10.0;

void setup(){
  size(576,576,P2D);

  energy = new ArrayList();

  int c =0;
  nodes = new ArrayList();
  for(int y = b ; y < height-b;y+=step){
    for(int x = b ; x < width-b;x+=step){
      nodes.add(new Node(x,y,c++));
    }
  }
  c=0;
  for(int y = b ; y < height-b;y+=step){
    for(int x = b ; x < width-b;x+=step){
      Node n = (Node)nodes.get(c++);
      n.reconnect();
    }
  }
}

void draw(){

  background(15);
  for(int i = 0; i < nodes.size();i++){
    Node n = (Node)nodes.get(i);
    n.drawConnections();
  }
  float sum = 0;
  for(int i = 0; i < nodes.size();i++){
    Node n = (Node)nodes.get(i);
    n.draw();
    sum+=n.val;
  }
  sum/=(nodes.size()+0.0);
  energy.add((float)(sum));

  //scatter = 60.0/((Float)energy.get(0)*60.0);
  
  scatter = 60.0/((sum)*30.0);
  //scatter = (sum*20.0);
  
  if(energy.size()>width)
    energy.remove(0);

  stroke(255,120);
  noFill();
  beginShape();
  for(int i = 0; i < energy.size();i++){
    float f = (Float)energy.get(i);
    float y = map(f,0,1,height,height-100);
    vertex(i,y);
  }
  endShape();
}


class Node{

  PVector pos;
  float val;
  ArrayList connections;
  int id;


  Node(float _x, float _y, int _id){
    id = _id;
    pos = new PVector(_x,_y);
    val = random(0,89)/100.0;
  }

  void reconnect(){
    connections = new ArrayList();
    for(int i = 0;i<numC;i++){
      Node _b = this;
      float d = 101;
      int c = 0;
      while(_b==this || d > area || c > 1000){
        _b = (Node)nodes.get((int)random(nodes.size()));
        d = dist(pos.x,pos.y,_b.pos.x,_b.pos.y);
        c++;
      }
      connections.add(new Connection(this, _b));
    }
  }

  void mutate(){
    //connections = new ArrayList();
      Node _b = this;
      float d = 101;
      int c = 0;
      while(_b==this || d > area || c > 1000){
        _b = (Node)nodes.get((int)random(nodes.size()));
        d = dist(pos.x,pos.y,_b.pos.x,_b.pos.y);
        c++;
      }
      connections.add(new Connection(this, _b));
      connections.remove(0);
  }
  void drawConnections(){
    for(int i = 0 ; i < connections.size();i++){
      Connection c = (Connection)connections.get(i);
      c.draw();
      if(move){
      pos.x+=(c.b.pos.x-pos.x)/slowdown;
      pos.y+=(c.b.pos.y-pos.y)/slowdown;
      c.b.pos.x-=(pos.x-c.b.pos.x)/slowdown;
      c.b.pos.y-=(pos.y-c.b.pos.y)/slowdown;
    }
    }
  }

  void trigger(){
    for(int i = 0 ; i < connections.size();i++){
      Connection c = (Connection)connections.get(i);
      c.trigger();
    } 
  }

  void draw(){
    if(frameCount==1 && id==0){
      trigger();
    }
    fill(255,val*255);
    noStroke();
    rect(pos.x-2,pos.y-2,4,4);

    //val*=0.98;
  }
}

class Connection{
  int id;
  Node a,b;
  float sig = -1;
  float weight;
  float oscSpeed;
  float startTime = 0;
  PVector sigpos;

  Connection(Node _a,Node _b){
    a=_a;
    b=_b;
    sigpos = new PVector(a.pos.x,a.pos.y);
    oscSpeed = lerp(120-scatter,120+scatter,((a.val+b.val)/2.0))/120.0;
  }

  void trigger(){
    startTime=millis();
    sig = 0;
  }

  void draw(){

    weight = sin(millis()/1000.0*TWO_PI*oscSpeed);
    stroke(255,map(weight,-1,1,0,75));

    line(a.pos.x,a.pos.y,b.pos.x,b.pos.y);

    if(sig > -1.0){
      noFill();
      rect(sigpos.x-1,sigpos.y-1,2,2);


      sigpos.x = lerp(a.pos.x,b.pos.x,sig);
      sigpos.y = lerp(a.pos.y,b.pos.y,sig);

      for(int i = 0; i < 10;i++){
        a.val*=0.999;
        weight = sin((millis()-startTime)/1000.0*TWO_PI*oscSpeed);
        sig = (millis()-startTime)/1000.0*map(weight,-1,1,0.9,1.1);
        if(sig>1.0){
          b.val=0.9+sig/100.0;
          sig = -1.0;
          b.mutate();
          b.trigger();
        }
      }
    }
  }
}

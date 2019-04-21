OscRecordReader oscr;

float SCALE = 8.0;

void setup() {
  size(640, 640, OPENGL);
  oscr = new OscRecordReader("/home/kof/1554146193_oscrec.txt");
}

void draw() {
  background(255);
  stroke(0);
  pushMatrix();
  rotateY(frameCount/6000.0*TWO_PI);
  oscr.draw();
  popMatrix();
}



class OscRecordReader {
  String raw[];
  String filename;
  ArrayList data;

  PVector acc,vel,pos;
  ArrayList positions;
  double time = 0;

  OscRecordReader(String _filename) {
    
    filename=_filename;
    raw = loadStrings(filename);
    
    
    parse();
    
    Record first = (Record)(data.get(0));
    acc = new PVector(first.acc.x,first.acc.y,first.acc.z);
    pos = new PVector(0,0,0);
    vel = new PVector(0,0,0);
    
    
    positions = new ArrayList();
    for (int i = 0; i < data.size(); i++) {
      Record tmp = (Record)data.get(i);
      compute(tmp);
      
      println(tmp.time);
     // time=tmp.time;
   
      
      positions.add(pos.copy());
     
    }
  }

  void parse() {
    data=new ArrayList();
    for (int i = 0; i < raw.length; i++) {
      String line[] =  splitTokens(raw[i], "<-,/ ");

      float time = parseFloat(line[0]);
      float x = parseFloat(line[2]);
      float y = parseFloat(line[3]);
      float z = parseFloat(line[4]);
      data.add(new Record(time, new PVector(x, y, z)));
    }
  }

  void draw() {
    noFill();
    
    
    
    
    pushMatrix();
    translate(width/2,height/2);
    scale(SCALE);
    strokeWeight(1/SCALE);
    
    /*
    beginShape();
    for (int i = 0; i < data.size(); i++) {
      stroke(0);
      PVector tmp = (PVector)positions.get(i);
      vertex(tmp.x, tmp.y, tmp.z);
    };
    endShape();
   */
   
    beginShape();
    for (int i = 0; i < data.size(); i++) {
      Record tmp = (Record)data.get(i);
      stroke(0,25);
      vertex(tmp.x, tmp.y, tmp.z);
    };
    endShape();
   
    popMatrix();
  }
  
  void compute(Record rec){
   acc = new PVector(rec.acc.x,rec.acc.y,rec.acc.z );
   //pos = new PVector(acc.x,acc.y,acc.z);
   //rec.acc.copy().sub(acc.copy()).copy();
   vel.add(acc);
   pos.add(vel);
   vel.mult(0.9806);
   // pos.mult(0.9806);
}
}

class Record {
  float time;
  float x,y,z;
  PVector acc;
  Record(float _time, PVector _acc) {
    time = _time;
    acc = _acc.copy();
    x=acc.x;
    y=acc.y;
    z=acc.z;
  }
}

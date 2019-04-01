OscRecordReader oscr;

float SCALE = 20.0;

void setup() {
  size(640, 640, P3D);
  oscr = new OscRecordReader("/home/kof/1554146193_oscrec.txt");
}

void draw() {
  background(255);
  stroke(0);
  pushMatrix();
  rotateY(frameCount/600.0*TWO_PI);
  oscr.draw();
  popMatrix();
}



class OscRecordReader {
  String raw[];
  String filename;
  ArrayList data;

  PVector acc,vel,pos;
  ArrayList positions;

  OscRecordReader(String _filename) {
    
    filename=_filename;
    raw = loadStrings(filename);
    
    pos = new PVector(0,0,0);
    acc = new PVector(0,0,0);
    vel = new PVector(0,0,0);
    
    parse();
    
    
    positions = new ArrayList();
    for (int i = 0; i < data.size(); i++) {
      Record tmp = (Record)data.get(i);
      compute(tmp);
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
    beginShape();
    for (int i = 0; i < data.size(); i++) {
      stroke(0);
      PVector tmp = (PVector)positions.get(i);
      vertex(tmp.x, tmp.y, tmp.z);
    };
    endShape();
   
    beginShape();
    for (int i = 0; i < data.size(); i++) {
      Record tmp = (Record)data.get(i);
      stroke(255,0,0,50);
      vertex(tmp.x, tmp.y, tmp.z);
    };
    endShape();
    popMatrix();
  }
  
  void compute(Record rec){
   acc = rec.acc.copy().sub(acc.copy()).copy();
   vel.add(acc);
   pos.add(vel);
   vel.mult(0.9806);
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

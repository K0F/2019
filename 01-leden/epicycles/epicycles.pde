import java.util.Collections;
import java.util.Comparator;

float re, im;
ArrayList pos;
int N = 200;
float time = 0 ;
float dt;
ArrayList wave;

ArrayList fourier;

void setup() {
  size(800, 800,P2D);
  wave = new ArrayList();

  fourier = new ArrayList();
  pos = new ArrayList();
  
  reset();
}

void mouseReleased(){
  reset();
}

void draw() {

  background(0);
  translate(width/2,height/2);
  PVector vx = drawFourier(0, 0, 0, fourier);
  wave.add(new PVector(vx.x,vx.y));

  if (wave.size()>N*4)
    wave.remove(0);

  stroke(255,150);
  noFill();
  beginShape();
  for (int i = 0; i < wave.size(); i++) {
    PVector tmp = (PVector)wave.get(i);
    vertex(tmp.x, tmp.y);
  }
  endShape();

  dt = TWO_PI / (float)pos.size();
  time += dt;

  if(time>TWO_PI){
    reset();
  }

}

void reset(){
  time=time-TWO_PI;
  pos = new ArrayList();
  for(int i = 0 ; i < N;i++){
    pos.add(new PVector(cos(i/10.0*TWO_PI)*200.0,sin(i/11.0*TWO_PI)*200.0));
  }

  fourier = dft(pos);
}

PVector drawFourier(float cx, float cy, float rotation, ArrayList fourier) {
  float x = cx;
  float y = cy;

  for (int i = 0; i < fourier.size(); i++) {

    Epicycle ff = (Epicycle)fourier.get(i);
    float prevx = x;
    float prevy = y;
    float radius = ff.amp;
    float angle = ff.phase + time * ff.freq + rotation;

    x += radius * cos(angle);
    y += radius * sin(angle);

    stroke(255, 50);
    noFill();
    ellipse(prevx, prevy, radius * 2, radius * 2);

    stroke(255, 70);
    line(prevx, prevy, x, y);

  }
  return new PVector(x, y);
}

ArrayList dft(ArrayList pos) {
  int N = pos.size();
  ArrayList X = new ArrayList();

  for (int k = 0; k < N; k++) {
    re = 0;
    im = 0;

    for (int n = 0; n < N; n++) {
      PVector tmp = (PVector)pos.get(n);
      float phiX = (TWO_PI * k * (n)) / (N);

      re += tmp.x * cos(phiX);
      im -= tmp.x * sin(phiX);
    }

    re = re / (N);
    im = im / (N);

    float freq = k;
    float amp = sqrt(re * re + im * im);
    float phase = atan2(im, re);

    X.add( new Epicycle(re, im, freq, amp, phase) );

    re = 0;
    im = 0;

    for (int n = 0; n < N; n++) {
      PVector tmp = (PVector)pos.get(n);
      float phiY = (TWO_PI * k * (n)) / (N) + HALF_PI;

      re += tmp.y * cos(phiY);
      im -= tmp.y * sin(phiY);
    }

    re = re / (N);
    im = im / (N);

    freq = k;
    amp = sqrt(re * re + im * im);
    phase = atan2(im, re);

    X.add( new Epicycle(re, im, freq, amp, phase) );

  }

  //Collections.sort(X, new CustomComparator());

  return X;
}


class Epicycle {
  float re, im, freq, amp, phase;

  Epicycle(float _re, float _im, float _freq, float _amp, float _phase) {
    re = _re;
    im = _im;
    freq = _freq;
    amp = _amp;
    phase = _phase;
  }

  float getAmp(){
    return amp;
  }
} 

public class CustomComparator implements Comparator<Epicycle> {
  @Override
    public int compare(Epicycle o1, Epicycle o2) {
      return (int)(o2.amp - o1.amp);
    }
}

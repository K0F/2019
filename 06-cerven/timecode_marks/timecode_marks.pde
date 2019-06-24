

ArrayList marks;
String tc;
int fr, se, mi, ho;
int rate = 25;
float offset;
boolean count = false;
float avgs;

void setup() {
  size(1280, 480, P2D); 
  textFont(createFont("Monospace", 9, true));  
  frameRate(rate);
  marks = new ArrayList();
  textAlign(CENTER);
  avgs = 60.0;
}

void draw() {
  background(0); 

  if (fr >= rate) {
    fr=0;
    se++;
  }

  if (se>59) {
    se=0;
    mi++;
  }

  if (mi>59) {
    mi=0;
    ho++;
  }

  fill(255);
  tc = nf(ho, 2)+":"+nf(mi, 2)+":"+nf(se, 2)+":"+nf(fr, 2);
  text(tc, width/2, 20);

  float avg = 0, diffmin = 1000.0, diffmax = 0.0001;

  pushStyle();
  colorMode(HSB);

  if (marks.size()>0)
    for (int i = 1; i < marks.size(); i++) {
      Mark tmp = (Mark)marks.get(i);
      float x = map(tmp.time, 0, millis()-offset, 100, width-100);

      Mark pre = (Mark)marks.get(i-1);
      float x2 = map(pre.time, 0, millis()-offset, 100, width-100);
      float diff =  (tmp.hours-pre.hours)*60.0*60.0+(tmp.minutes-pre.minutes)*60.0+(tmp.seconds-pre.seconds)+(tmp.frames-pre.frames)*(1.0/rate+0.0);
      float y = map(diff, diffmin, diffmax, -100.0, 100.0);

      if (diff>0) {
        diffmin = min(diff, diffmin);
        diffmax = max(diff, diffmax);

        float xmid = lerp(x, x2, 0.5);

        color dd = color(map(diff, diffmin, diffmax, 230.0, 0), 200, 255);//lerpColor(#ffcc00,#00ccff,map(diff,diffmin,diffmax,0.0,1.0));
        fill(dd);
        stroke(dd, 120);
        line(x, height/3+y, x2, height/3+y);
        fill(hue(dd), i%2==0?127:255, 255);
        rect(x, height/3*2 +  ((i%2)*10), x2-x, 10);
        text(diff+"s", xmid, height/3+y-10);
        noStroke();
        triangle(x, height/3+y, x-6, height/3+y+3, x-6, height/3+y-3);
        stroke(dd, 200);

        avg += (diff);
      }

      //stroke(255, 50);
      line(x, 0, x, height);
      //fill(255);
      pushMatrix();
      translate(x, height/3*2+50);
      rotate(-QUARTER_PI);
      fill(255, 0, 255);
      text(nf(tmp.hours, 2)+":"+nf(tmp.minutes, 2)+":"+nf(tmp.seconds, 2)+":"+nf(tmp.frames, 2), 0, 0);
      popMatrix();
    }


  popStyle();  
  colorMode(HSB);

  if (marks.size()>0) {
    avg = avg/(marks.size()+0.0);

    avgs += ( avg - avgs ) / 3.0;

    fill(#ffcc00);
    
    text( avgs + "s ~ " + (1.0/avgs) * 60.0 + " bpm" , width/2 , 30 );
    color ff = color( map( avgs, diffmin, diffmax, 230.0, 0 ) );
    fill( ff, 0.5 * ( sin(( millis() - offset) / 1000.0 / avgs * TWO_PI + HALF_PI) + 1.0 )  * 255);
    rect(width/2 -7.5, 50, 15, 15);
  }



  if (count)
    fr++;
}

void keyPressed() {
  if (key==' ' || keyCode==ENTER) {
    if (marks.size()==0) {
      offset=millis();
      count=true;
    }

    marks.add(new Mark(ho, mi, se, fr));
  }

  if (key=='s') {
    String [] tcs = new String[marks.size()];

    for (int i = 0; i < marks.size(); i++) {
      Mark tmp = (Mark)marks.get(i);
      tcs[i] = nf(tmp.hours, 2)+":"+nf(tmp.minutes, 2)+":"+nf(tmp.seconds, 2)+":"+nf(tmp.frames, 2);
    }
    saveStrings("timecodes.txt", tcs);
  }

  if (keyCode==BACKSPACE) {
    offset = millis();
    marks = new ArrayList();
    fr = mi = ho =se = 0;
    avgs = 60.0;
  }
}

class Mark {
  float time;
  int hours, minutes, seconds, frames;

  Mark() {
    time = millis()-offset;
  }


  Mark(int _hours, int _minutes, int _seconds, int _frames) {
    time = millis()-offset;
    hours=_hours;
    minutes=_minutes;
    seconds=_seconds;
    frames=_frames;
  }
}

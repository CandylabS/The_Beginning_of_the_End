/*********** 6 part ************/
void IMPROVISATION(){
  //println("IMPROVISATION");
  /*** UDP MOTION INPUT ***/// from Carren
  /// FLUFFY BALL ///
  /*** MIDI AUDIO INPUT ***/// from Carren
  //if (noteOn == true) dotMap();
  //ring(1);
  loadPixels();
  WebCam(false);
  ring(1);
}

void ring(int file){// file number from 0-2
  fill(0);  // background color
  noStroke();
  if (file!=1){
    if (EP == 7) image(themeImage, width/2, height/2);
    else rect(0, 0, canvas_width, canvas_height);
  }
  pushMatrix();
  translate(canvas_width/2, canvas_height/2);
  beginShape();
  noFill();
  stroke(128, 50);
  strokeWeight(1.5);
  //stroke(255);
  int bsize = player.get(file).bufferSize();
  //int r = 300;
  int[] r = new int[num];
  int dr = 10;
  for (int i=0; i<num; i++){
    r[i] = 300 + dr * i;
  }
  for (int j=0; j<r.length; j++){
    float x1 = (r[j] + player.get(file).mix.get(0)*100)*cos(0);
    float y1 = (r[j] + player.get(file).mix.get(0)*100)*sin(0);
    for (int i = 0; i < bsize; i+=30)
    {
     float x2 = (r[j] + player.get(file).mix.get(i)*100)*cos(i*2*PI/bsize);
     float y2 = (r[j] + player.get(file).mix.get(i)*100)*sin(i*2*PI/bsize);
     line(x2, y2, x1, y1);
     vertex(x2, y2);
     x1 = x2;
     y1 = y2;
     pushStyle();
     stroke(255);
     strokeWeight(4);
     point(x2, y2);
     popStyle();
    }
  }
  endShape();
  popMatrix();
}
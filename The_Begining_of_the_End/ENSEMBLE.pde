/*********** 7 part ************/
void ENSEMBLE(){
  //println("ENSEMBLE"); 
  /*** MIDI AUDIO INPUT ***/// from Carren
  ring(2);
  
  ///*** UDP MOTION INPUT ***/// from Carren
  ///// FLUFFY BALL ///
  noiseSphere();
  //// change color to red //
  
  ///*** MIDI AUDIO INPUT ***/// from Lea
  Piano();
  boom();
  //drawGradient(x, y);
}

void drawGradient(float x, float y) {
  pushStyle();
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  int s = 30;
  int b = 0;
  float h = random(0, 360);
  for (int r = int(radio); r > 0; r-=3) {
    fill(h, s, b);
    //ellipse(x, y, r, r);
    sphere(r);
    b = (b + 1) % 99;
  }
  popStyle();
}
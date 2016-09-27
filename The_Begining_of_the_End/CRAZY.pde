/*********** 8 part ************/
void CRAZY(){
  // Computer MIC Audio Input
  microphone();
  noiseSphere();
  dotMap();
  
}

void microphone(){
      // adjust the volume of the audio input
    input.amp(map(mouseY, 0, height, 0.0, 1.0));
    
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    scale=int(map(rms.analyze(), 0, 0.5, 1, 30));
}

// THIS VERSION TOO MUCH DELAY
void dotMap(){
  float pointillize = map(mouseX, 0, 800, smallPoint, largePoint);
  for (int i=0; i<scale; i++){
    int x = int(random(dotImage.width));
    int y = int(random(dotImage.height));
    color pix = dotImage.get(x, y);
    noStroke();
    fill(pix, 128);
    float X = map(x, 0, dotImage.width, 0, 1280);
    float Y = map(y, 0, dotImage.height, 0, 800);
    ellipse(X, Y, pointillize, pointillize);
  }
}
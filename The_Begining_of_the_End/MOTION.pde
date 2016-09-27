/*********** 2 part ************/
void MOTION(){
  //println("MOTION");
  /*** WEBCAM INPUT ***/// from Alice
  WebCam(true);
  
  /*** UDP MOTION INPUT ***/// from Carren
  
  /*** KINECT INPUT ***/// from Carren
  
  // use StoringInput (delay effect)
  ellipse(handR, 600, 30, 30); 
  //ellipse(handR, 600, 50, 50); 
  ellipse(handL, 600, 30, 30); 
  //ellipse(handL, 600, 50, 50); 
  
  ///// ADDITION 1 /////
  ///*** CHANGE FIGURE ***///
}

void storing(){
  // Cycle through the array, using a different entry on each frame. 
  // Using modulo (%) like this is faster than moving all the values over.
  noStroke();
  fill(255, 153); 
  int which = frameCount % numCircle;
  //mx[which] = mouseX;
  //my[which] = mouseY;
  mx[which] = handR;
  my[which] = handR;
  nx[which] = handL;
  ny[which] = handL;
  
  for (int i = 0; i < numCircle; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % numCircle;
    ellipse(mx[index], my[index], i, i);
  }
  for (int i = 0; i < numCircle; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % numCircle;
    ellipse(nx[index], ny[index], i, i);
  }
}
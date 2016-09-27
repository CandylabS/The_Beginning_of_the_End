/*********** 1st part ************/
void AWAKE(){
  //println("AWAKE");
  /*** WEBCAM INPUT ***/// from Alice
  WebCam(true);
  ///// ADDITION 1 /////
  ///*** TYPEWRITER ***///
  thinking(wordNum);
  
  ///// ADDITION 2 /////
  ///*** FISH EYE ***///
  // by moving my own mouse
}

void thinking(int num){
  textFont(shimonFont, 90);
  if (((num%2)==0) && (((num/2>0)&&(num/2<8)))) text(words.get(num/2-1), mouseX, mouseY);
}

void WebCam(boolean toggle){
  if (cam.available() == true) {
   cam.read();
   cam.loadPixels();
   if (EP == 1) frameDiff(cam);
   else plainFrame(cam);
  }
  pushMatrix();
  translate(canvas_width/2, canvas_height/2);
  imageMode(CENTER);
  //if (EP >= 2) image(cam, 0, 0);
  if (toggle){
    if (blink == false){
     image(maskImage, 0, 0);
    }else{
     image(blinkImage, 0, 0);
     if (timer.elapsedMillis() > 500) {
       println("1 second has passed");
       blink = false;
     }
    }
  }
  popMatrix();
}

void plainFrame(Capture camera){
   for (int i = 0; i < numPixels; i++){
     color C = camera.pixels[i];
     // Extract the red, green, and blue components from current pixel
     int r = (C >> 16) & 0xFF; // Like red(), but faster
     int g = (C >> 8) & 0xFF;
     int b = C & 0xFF;
     float maxdist = 150;//dist(0,0,width,height);
     float d = dist(i%1920, i/1920*1.5, 640, 400);
     float adjustbrightness = 255*(maxdist-d)/maxdist;
     r += adjustbrightness; r = min(r, alpha);
     g += adjustbrightness; g = min(g, alpha);
     b += adjustbrightness; b = min(b, alpha);
     pixels[i] = color(r, g, b); 
     updatePixels();
   }
}

void frameDiff(Capture camera){
    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = camera.pixels[i];
      color prevColor = previousFrame[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }
    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.
    if (movementSum > 0) {
      updatePixels();
      println(movementSum); // Print the total amount of movement to the console
    }
}
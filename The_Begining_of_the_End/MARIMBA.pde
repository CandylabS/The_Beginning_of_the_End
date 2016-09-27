/*********** 3 part ************/
void MARIMBA(){
  //println("MOTION");
  
  /*** WEBCAM INPUT ***/// from Alice
  WebCam(true); 
  
  ///// ADDITION /////
  /* eyes close */
  /* fluffy ball on */
  //noiseSphere();
}

void noiseSphere(){
  if (speed == 0) gravity_y = 1.0;
  else gravity_y = 0.5;
  if (!((!k)&&(y<=400))){
    x += dx;
    y += dy;

    dx += gravity_x;
    dy += gravity_y;
  }
  else dy = 0;
  if (y + 160 >= 600) {
    k = false;
    y = 600 - 160;
    dy = -(dy * elasticity);
  }
  if (x + 160 >= 900) {
    x = 900 - 160;
    dx = -(dx * elasticity);
  }
  translate(x+basePan*50, y+neckTilt*50);           // translate x & y : degree 5&6
  //translate(x, y);
  //float rxp = ((mouseX-(width/2))*0.005);    // mouseX: degree 1
  //float ryp = ((mouseY-(height/2))*0.005);    // mouseY: degree 2
  float rxp, ryp;
  if (!((!k)&&(y<=400))){
    rxp = 2;
    ryp = 2;
  }
  else{
    rxp = neckPan*5;
    ryp = headTilt*2;
  }
  rx = (rx*0.9)+(rxp*0.1);
  ry = (ry*0.9)+(ryp*0.1);
  rotateY(rx);
  rotateX(ry);
  if (EP == 7){
    pushStyle();
    colorMode(HSB, 360, 100, 100);
    noStroke();
    ellipseMode(RADIUS);
    int s = 30;
    int b = 99;
    float h = random(0, 360);
    if (radio>height/5) fill(h,s,b);
    else fill(0);
    noStroke();
    pointLight(51, 51, 51, 0, 0, 400);
    sphere(radio);
    popStyle();
  }
  else{
    fill(0);  // ball color: degree 3
    noStroke();
    sphere(radio);  // ball radius: degree 4
  }

  for (int i = 0;i < cuantos; i++) {
    lista[i].dibujar();
  }
}

void boom(){
  if (noteOn){
    radio *= 1.2;
    noteOn = false;
  }
  if (timer.elapsedMillis() > 100) {
     radio = height/5;
   }
}


void cuantos(int EP){
  if (EP == 6) cuantos = 500;
  else if (EP == 7) cuantos = 1000;
  else if (EP == 8) cuantos = 2000;
  lista = new Pelo[cuantos];
  for (int i=0; i<cuantos; i++) {
    lista[i] = new Pelo();
  }
}
/*********** 4 part ************/
void TEACHER(){
  //println("TEACHER");  
  /*** MIDI AUDIO INPUT ***/// from Carren
  ring(0);
  
  /*** UDP MOTION INPUT ***/// from Carren
  // FLUFFY BALL //
  noiseSphere();
  
  /*** MIDI AUDIO INPUT ***/// from Lea
  Piano();
  boom();
  //dotMap();
}

void Piano(){  
  try { //All the methods of SysexMessage, ShortMessage, etc, require try catch blocks
  SysexMessage message = new SysexMessage();
  message.setMessage(
    0xF0, 
    new byte[] {
      (byte)0x5, (byte)0x6, (byte)0x7, (byte)0x8, (byte)0xF7
    },
    5
  );
  myBus.sendMessage(message);
  } catch(Exception e) {

  }

  delay(50);
}
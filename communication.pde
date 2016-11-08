
Serial myPort;
float [] arrayIn = new float[3];
int serialCount = 0;
boolean firstContact = false;


void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    arrayIn[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      con = arrayIn[0]/60;
      res = arrayIn[1]/500000;
      conv = arrayIn[2];

      // print the values (for debugging purposes only):
      //println(xpos + "\t" + ypos + "\t" + fgcolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
char incomingChar = '$';
String incomingString;

void setup()
{
  Serial.begin(57600);
  while ( !Serial ) {}
  Serial.println("Hello World");
  
}

void loop() {
   
  if (Serial.available() {
    incomingChar = Serial.read();
    Serial.println(incomingChar);
    Serial.print(' ');
  }
  
  /*
  if ( Serial.availalbe() {
    incomingString = Serial.readString();
    Serial.println(incomingString);
  }
  */
}

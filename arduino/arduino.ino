int interruptPin = 8; // connected to 8051 INT0 (P3.2)

void setup() {
  pinMode(interruptPin, OUTPUT);
  digitalWrite(interruptPin, LOW);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    char c = Serial.read();
    if (c == '1') {
      digitalWrite(interruptPin, HIGH);
      delay(200);
      digitalWrite(interruptPin, LOW);
    }
  }
}

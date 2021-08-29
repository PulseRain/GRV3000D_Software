void setup() {
    delay(1000);
}

int index = 0;
void loop() {

    GPIO_P1 = 0x00;

    delay (1000);

    GPIO_P1 = 0xff;
    delay (1000);

    Serial.print ("ABCDE ");
    Serial.println(index++);
 
}

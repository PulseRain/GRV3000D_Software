//==================================================================================================
// PulseRain Technology, LLC
//
// Using Ctrl-U to compile and upload this sketch,
// then use Ctrl-Shift-M to open Serial Monitor
//
//==================================================================================================

void setup() {

    uint8_t c;
    uint8_t vol = 20;

    *REG_ROTARY_ENCODER = vol;
    
    do {
        c = 0;
        
        if (Serial.available()) {
            c = Serial.read();    
        }

        delay (200);

        Serial.print("====== Volume: ");
        vol = *REG_ROTARY_ENCODER;
        Serial.println(vol);

        
    } while ((c != 'q') &&  (c != 'Q'));
    
}


void loop() {

}

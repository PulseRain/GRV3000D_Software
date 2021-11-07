//==================================================================================================
// PulseRain Technology, LLC
//
// Demonstration for Lattice MACHXO3D Breakout Board
// 
// Using Ctrl-U to compile and upload this sketch,
// then use Ctrl-Shift-M to open Serial Monitor
//
//==================================================================================================


void setup() {
    uint32_t ad, da, t;
    uint8_t c;

    *REG_CODEC_AD_STATUS_REG = 0;
    *REG_CODEC_DA_STATUS_REG = 0;

   do {
        
        t = *REG_CODEC_AD_DATA_REG;
        ad = *REG_CODEC_AD_STATUS_REG;
        
        
   } while (ad & 2);

   do {
        
        *REG_CODEC_DA_DATA_REG = 0;
        da = *REG_CODEC_DA_STATUS_REG;
        
        
   } while ((da & 4) == 0);

  Serial.println ("Enable CODEC");
  
  *REG_CODEC_AD_STATUS_REG = 1;
  *REG_CODEC_DA_STATUS_REG = 1;
  
   do {
      c = 0;

      if (Serial.available()) {
            c = Serial.read();    
      }

      ad = *REG_CODEC_AD_STATUS_REG;

      if (ad & 2) {
        //Serial.println("ddd");
        t = *REG_CODEC_AD_DATA_REG;
        *REG_CODEC_DA_DATA_REG = t;
      }
      
   } while ((c != 'q') &&  (c != 'Q'));
}


void loop() {

}

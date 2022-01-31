
//==================================================================================================
// Sketch to demo interrupt handling
//
// This sketch will turn on one of the Seven Segment Display on the board and show a counter.
// Use the 5 way nativation Switch to adjust the counter.
//
// The center key will freeze/clear the counter.
// The Up/Down key will adjust the value of the counter
// The Left/Right key will set the counter to be counting up or counting down.
//
//==================================================================================================

//----------------------------------------------------------------------------
//  Class for the 7-segment display on GRV3000D for Nexys FPGA board 
//----------------------------------------------------------------------------

class Seven_Seg_Display
{
    public:
    
//----------------------------------------------------------------------------
// reset()
//
// Parameters:
//      value_to_display    : 16 bit value to be displayed on the 4-position
//           7-seg display
//
//      refresh_rate_in_Hz  : refresh rate for the 7-segment display. It is 
//           suggested to be no more than 400 Hz to avoid flicking 
//
//      active_dp_mask      : 4 bit mask for the decimal point. 0xF to be all 
//           on, 0x0 to be all off.
//     
// Return Value:
//      None
//
// Remarks:
//      Function to set the value / refresh_frequency for 7-seg display
//----------------------------------------------------------------------------
        void reset (uint16_t value_to_display, uint32_t refresh_rate_in_Hz, uint8_t active_dp_mask  = 0)
        {
            value_ = value_to_display;
            index_ = 0;
            active_dp_mask_ = active_dp_mask;
            
            refresh_count_ = TIMER_RESOLUTION / refresh_rate_in_Hz;
        }



//----------------------------------------------------------------------------
// Seven_Seg_Display()
//
// Parameters:
//      value_to_display    : 16 bit value to be displayed on the 4-position
//           7-seg display
//
//      refresh_rate_in_Hz  : refresh rate for the 7-segment display. It is 
//           suggested to be no more than 400 Hz to avoid flicking 
//
//      active_dp_mask      : 4 bit mask for the decimal point. 0xF to be all 
//           on, 0x0 to be all off.
//     
// Return Value:
//      None
//
// Remarks:
//      constructor for the class
//----------------------------------------------------------------------------

        Seven_Seg_Display (uint16_t value_to_display, uint32_t refresh_rate_in_Hz) 
        {
            reset (value_to_display, refresh_rate_in_Hz); 
        }



//----------------------------------------------------------------------------
// set_display_value()
//
// Parameters:
//      value           : 16 bit value to be displayed on the 4-position 
//               7-seg display
//
//      active_dp_mask  : 4 bit mask for the decimal point. 0xF to be all 
//           on, 0x0 to be all off.
//     
// Return Value:
//      None
//
// Remarks:
//      change the display value for the 7-seg display
//----------------------------------------------------------------------------
        void set_display_value (uint16_t value, uint8_t active_dp_mask)
        {
            value_          = value;
            active_dp_mask_ = active_dp_mask;
        }
        
//----------------------------------------------------------------------------
// start_refresh()
//
// Parameters:
//      None
//     
// Return Value:
//      None
//
// Remarks:
//      Install the timer ISR for 7-seg display
//----------------------------------------------------------------------------
        
        void start_refresh ()
        { 
            timer_advance_ (refresh_count_);
            attachInterrupt (INT_TIMER_INDEX, seven_segment_display_timer_isr_, RISING);
        }

//----------------------------------------------------------------------------
// stop_refresh()
//
// Parameters:
//      None
//     
// Return Value:
//      None
//
// Remarks:
//      Uninstall the timer ISR for 7-seg display
//----------------------------------------------------------------------------

        void stop_refresh ()
        {
            detachInterrupt (INT_TIMER_INDEX);      
        }


    private:

//----------------------------------------------------------------------------
//  Internal variables
//----------------------------------------------------------------------------
        static uint16_t value_;
        static uint8_t index_;
        static uint8_t active_dp_mask_;
        static uint32_t refresh_count_;

//----------------------------------------------------------------------------
//  display format for 7-segment display
//----------------------------------------------------------------------------

        static constexpr uint8_t seven_seg_display_encoding_ [16] = {
           0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 
        };

//----------------------------------------------------------------------------
// timer_advance_()
//
// Parameters:
//      count : the number of ticks to advance for the system timer
//     
// Return Value:
//      None
//
// Remarks:
//      Internal function to advance system timer
//----------------------------------------------------------------------------

        static void timer_advance_ (uint32_t count)
        {
            uint32_t low, high;
            uint64_t finish_time, current_time;
            uint32_t interrupt_saved_mstatus_timer_advance;

            interrupt_saved_mstatus_timer_advance = read_csr (mstatus);
            
            write_csr (mstatus, 0);
                low  = (*REG_MTIME_LOW);
                high = (*REG_MTIME_HIGH);
            finish_time = ((uint64_t)high << 32) + (uint64_t)(low) + (uint64_t)count;
    
                low  = finish_time & 0xFFFFFFFF;
                high = (finish_time >> 32) & 0xFFFFFFFF;
    
            (*REG_MTIMECMP_LOW) = 0xFFFFFFFF;
            (*REG_MTIMECMP_HIGH) = high;
            (*REG_MTIMECMP_LOW)  = low ;    

            write_csr (mstatus, interrupt_saved_mstatus_timer_advance);
        }

//----------------------------------------------------------------------------
// _refresh()
//
// Parameters:
//      None
//     
// Return Value:
//      None
//
// Remarks:
//      Internal function to move the active display position
//----------------------------------------------------------------------------
        static void _refresh ()
        {
            uint8_t t;
            uint32_t b1, b0;

            b1 = 1 << index_;
            t = (value_ >> (index_ * 4)) & 0xF;
            
            b0 = seven_seg_display_encoding_[t] | ((active_dp_mask_ >> index_) & 1) << 7;
            index_ = (index_ + 1) % 4;

            *((uint32_t*)REG_GPIO) = (b1 << 8) | b0;
        }


//----------------------------------------------------------------------------
// seven_segment_display_timer_isr_()
//
// Parameters:
//      None
//     
// Return Value:
//      None
//
// Remarks:
//      ISR for system timer
//----------------------------------------------------------------------------
        static void seven_segment_display_timer_isr_()
        {
            _refresh ();
            timer_advance_ (refresh_count_);
        }

};

uint16_t Seven_Seg_Display::value_;
uint32_t Seven_Seg_Display::refresh_count_;
uint8_t  Seven_Seg_Display::index_;
uint8_t  Seven_Seg_Display::active_dp_mask_;

Seven_Seg_Display SEVEN_SEG_DISPLAY (0xbeef, 400);


//================================================================================================================
// 5 way navigation switch
//================================================================================================================

uint8_t keys[256] = {0};
uint8_t key_write_point = 0;
uint8_t key_read_point = 0;

void int0_keys_isr()
{
  uint8_t t;

  t = GPIO_P2 & 0x1F;
  if (t) {
    keys[key_write_point++] = t;
  }
} // End of int0_keys_isr()



//================================================================================================================
// Setup and Loop
//================================================================================================================

void setup() {
   delay(1000);

   SEVEN_SEG_DISPLAY.start_refresh();
   attachInterrupt (INT_EXTERNAL_1ST, int0_keys_isr, RISING);

   interrupts();

}

void loop() {
  static int i = 0;
  static int count_step = 1;
  uint8_t k;

  i = i + count_step;
  Serial.print(i);
  Serial.write("\n");
  
  SEVEN_SEG_DISPLAY.set_display_value(i, 1);

  if (key_read_point != key_write_point) {
    //Serial.print("\n Key Pressed: ");
    do {
      k = keys[key_read_point++];

      if (k == 0x1) {
        //Serial.println(" Left");
        count_step = -1;
      } else if (k == 0x2) {
        //Serial.println(" Right");
        count_step = 1;
      } else if (k == 0x4) {
        //Serial.println(" Up");
        i= i + 1;
      } else if (k == 0x8) {
        //Serial.println(" Down");
        i = i - 1;
      } else {
        if (count_step == 0) {
          i = 0;
        }
        count_step = 0;
        //Serial.println(" Center");
      }

    } while (key_read_point != key_write_point);
  }

  if (count_step == 0) {
    delay(100); 
  } else {
    delay(1000);
  }

}

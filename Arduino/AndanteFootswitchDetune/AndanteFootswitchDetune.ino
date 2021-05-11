
/* For BLE MIDI Setup
   https://learn.adafruit.com/wireless-untztrument-using-ble-midi/overview
*/

#include <bluefruit.h>
#include <MIDI.h>

BLEDis bledis;
BLEMidi blemidi;

// Create a new instance of the Arduino MIDI Library, and attach BluefruitLE MIDI as the transport.
MIDI_CREATE_BLE_INSTANCE(blemidi);

enum songNames {
  CanonInD,
  Mario,
  IWantYouBack,
};

// update w more beats
int drumBeat = 0;

enum gaitStates {
  calibration,
  stance,
  toeOff,
  swingPreKnee,
  swingPostKnee,
  heelContact,
};


// states
songNames songName = CanonInD;
gaitStates gaitState = swingPreKnee;
bool playMelody = true;
bool playDrums = false;



int notesPerChord;
int numChords;
int melodyNotesPerChord;
int chordsPerStepCycle;



int ledPin = 17;

int heelPin = A1;
int heelVal = 0;
int lastHeelVal = 0;
int chordCounter = 0;
int prevChord = 0;
int drumCounter = 0;

int stepCounter = 0;
int numCalibrationSteps = 4;
float calibrationStepTimes[] = {0};
float strideFreq = 0;

float lastStepTime = 0;
float timeSinceLastStep = 0;
float lastTOTime = 0;
float timeSinceLastTO = 0;

int threshold = 500;

// timers
float ledOnTime = 0.0f;


void setup(){
  
  Serial.begin(115200);
  while ( !Serial ) delay(10);   // for nrf52840 with native usb

  Serial.println("Adafruit Bluefruit52 MIDI over Bluetooth LE Example");

  // Config the peripheral connection with maximum bandwidth
  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  Bluefruit.begin();
  Bluefruit.setName("Bluefruit52 MIDI");
  Bluefruit.setTxPower(4);

  // Setup the on board blue LED to be enabled on CONNECT
  Bluefruit.autoConnLed(true);

  // Configure and Start Device Information Service
  bledis.setManufacturer("Adafruit Industries");
  bledis.setModel("Bluefruit Feather52");
  bledis.begin();

  // Initialize MIDI, and listen to all MIDI channels, will also call blemidi service's begin()
  MIDI.begin(MIDI_CHANNEL_OMNI);

  // Attach the handleNoteOn function to the MIDI Library. It will
  // be called whenever the Bluefruit receives MIDI Note On messages.
  MIDI.setHandleNoteOn(handleNoteOn);

  // Do the same for MIDI Note Off messages.
  MIDI.setHandleNoteOff(handleNoteOff);

  // Set up and start advertising
  startAdv();

  // Start MIDI read loop
  Scheduler.startLoop(midiRead);

  // onboard LED to confirm footswitch function
  pinMode(ledPin, OUTPUT);  // built-in red LED


  switch (songName) {
    case CanonInD:
    {
      notesPerChord = 3;
      numChords = 8;
      melodyNotesPerChord = 8;
      chordsPerStepCycle = 1;
      bool melodyNotePlayed[melodyNotesPerChord] = {false};
      int melody[numChords][melodyNotesPerChord] = {
        {81, -1, 78, 79, 81, -1, 78, 79}, 
        {81, 69, 71, 73, 74, 76, 78, 79}, 
        {78, -1, 74, 76, 78, -1, 66, 67}, 
        {69, 71, 69, 67, 69, 66, 67, 69}, 
        {67, -1, 71, 69, 67, -1, 66, 64}, 
        {66, 64, 62, 64, 66, 67, 69, 71}, 
        {67, -1, 71, 69, 71, -1, 73, 74}, 
        {69, 71, 73, 74, 76, 78, 79, 81}
        };
      int chords[numChords][notesPerChord] = {
        {50, 57, 66}, 
        {45, 52, 61}, 
        {47, 54, 62}, 
        {42, 49, 57}, 
        {43, 50, 59}, 
        {50, 57, 66}, 
        {43, 50, 59}, 
        {45, 52, 61}
        };
      break;
    }
        
    case Mario:
    {
      notesPerChord = 3;
      numChords = 32;
      melodyNotesPerChord = 8;
      chordsPerStepCycle = 1;
      bool melodyNotePlayed[melodyNotesPerChord] = {false};
      int melody[numChords][melodyNotesPerChord] = {
        {60, -1, -1, 55, -1, -1, 52, -1}, 
        {-1, 57, -1, 59, -1, 58, 57, -1}, 
        {55, 64, -1, 67, 69, -1, 65, 67}, 
        {-1, 64, -1, 60, 62, 59, -1, -1}, 
        {60, -1, -1, 55, -1, -1, 52, -1}, 
        {-1, 57, -1, 59, -1, 58, 57, -1}, 
        {55, 60, -1, 67, 69, -1, 65, 67}, 
        {-1, -64, -1, 60, 62, 59, -1, -1},
        
        {-1, -1, 67, 66, 65, 63, -1, 64}, 
        {-1, 56, 57, 60, -1, 57, 60, 62}, 
        {-1, -1, 67, 66, 65, 63, -1, 64}, 
        {-1, 72, -1, 72, 72, -1, -1, -1}, 
        {-1, -1, 67, 66, 65, 63, -1, 64}, 
        {-1, 56, 57, 60, -1, 57, 60, 62}, 
        {-1, -1, 63, -1, -1, 62, -1, -1}, 
        {60, -1, -1, -1, -1, -1, -1, -1}, 
        
        {-1, -1, 67,  66, 65, 63, -1, 64}, 
        {-1, 56, 57,  60, -1, 57, 60, 62}, 
        {-1, -1, 67,  66, 65, 63, -1, 64}, 
        {-1, 72, -1,  72, 72, -1, -1, -1}, 
        {-1, -1, 67,  66, 65, 63, -1, 64}, 
        {-1, 56, 57,  60, -1, 57, 60, 62}, 
        {-1, -1, 63,  -1, -1, 62, -1, -1}, 
        {60, -1, -1,  -1, -1, -1, -1, -1}, 
        
        {60, 60, -1,  60, -1, 60, 62, -1}, 
        {64, 60, -1, 57, 55, -1, -1, -1}, 
        {60, 60, -1, 60, -1, 60, 62, 64}, 
        {-1, -1, -1, -1, -1, -1, -1, -1}, 
        {60, 60, -1, 60, -1, 60, 62, -1}, 
        {64, 60, -1, 57, 55, -1, -1, -1}, 
        {64, 64, -1, 64, -1, 60, 64, -1}, 
        {67, -1, -1, -1, 55, -1, -1, -1}, 
        };

      int chords[numChords][notesPerChord] = {
        {36, 43, 52}, 
        {41, 45, 48}, 
        {36, 43, 52}, 
        {31, 38, 47}, 
        {36, 43, 52}, 
        {41, 45, 48}, 
        {36, 43, 52}, 
        {31, 38, 47}, 
        
        {36, 43, 52}, 
        {41, 45, 48}, 
        {36, 43, 52}, 
        {31, 38, 47}, 
        {36, 43, 52}, 
        {41, 45, 48}, 
        {32, 39, 48}, 
        {36, 43, 52}, 
        
        {32, 39, 48}, 
        {31, 38, 47}, 
        {32, 39, 48}, 
        {31, 38, 47}, 
        {32, 39, 48}, 
        {31, 38, 47}, 
        {26, 35, 43}, 
        {31, 38, 47},
        };
      break;
    }
        
    case IWantYouBack:
    {
      notesPerChord = 3;
      numChords = 16;
      melodyNotesPerChord = 4;
      chordsPerStepCycle = 2;
      bool melodyNotePlayed[melodyNotesPerChord] = {false};
      int melody[numChords][melodyNotesPerChord] = {
        {32, -1, -1, -1}, 
        {-1, -1, -1, -1}, 
        {-1, -1, -1, 34}, 
        {36, 39, 41, 37}, 
        {-1, -1, -1, -1}, 
        {-1, -1, -1, -1}, 
        {-1, 34, 36, 37}, 
        {-1, 39, 40, -1}, 
        
        {41, -1, -1, -1}, 
        {36, -1, -1, -1}, 
        {37, -1, -1, 32}, 
        {-1, -1, -1, -1}, 
        {34, -1, -1, -1}, 
        {39, -1, -1, 32}, 
        {-1, -1, -1, -1}, 
        {-1, -1, -1, -1}, 
        };

      int chords[numChords][notesPerChord] = {
        {56, 60, 63}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {56, 61, 65}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        
        {56, 60, 65}, 
        {55, 60, 63}, 
        {56, 61, 65}, 
        {56, 60, 63}, 
        {58, 61, 65}, 
        {58, 63, 67}, 
        {56, 60, 63}, 
        {-1, -1, -1}, 
        };
      break;
    }
  }
  
  switch (drumBeat){
    case 0:
      int numDrums = 3;
      int drumHitsPerChord = melodyNotesPerChord;
      bool drumHitPlayed[drumHitsPerChord] = {false};
      int drums[numChords][drumHitsPerChord][numDrums] ={
        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },

        {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        },
      };
      
      break;
  }
}

void startAdv(void){
  
  // Set General Discoverable Mode flag
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);

  // Advertise TX Power
  Bluefruit.Advertising.addTxPower();

  // Advertise BLE MIDI Service
  Bluefruit.Advertising.addService(blemidi);

  // Secondary Scan Response packet (optional)
  Bluefruit.ScanResponse.addName();

  //Start Advertising
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);    // in unit of 0.625 ms
  Bluefruit.Advertising.setFastTimeout(30);      // number of seconds in fast mode
  Bluefruit.Advertising.start(0);                // 0 = Don't stop advertising after n seconds
}

void handleNoteOn(byte channel, byte pitch, byte velocity){
  
  // Log when a note is pressed.
  Serial.printf("Note on: channel = %d, pitch = %d, velocity - %d", channel, pitch, velocity);
  Serial.println();
}

void handleNoteOff(byte channel, byte pitch, byte velocity){
  
  // Log when a note is released.
  Serial.printf("Note off: channel = %d, pitch = %d, velocity - %d", channel, pitch, velocity);
  Serial.println();
}









void loop(){
  
  // Don't continue if we aren't connected.
  if (! Bluefruit.connected()) {
    // reset vals
    stepCounter = 0;
    chordCounter = 0;
    drumCounter = 0;
    strideFreq = 0;
    for (int i = 0; i < numCalibrationSteps; i++){
      calibrationStepTimes[i] = 0;
    }
    return;
  }

  heelVal = analogRead(heelPin);
  prevChord = (chordCounter - 1 + numChords) % numChords;


  switch (gaitState) {
    
    case calibration:
      // sense heel contact
      if (heelVal > threshold && lastHeelVal < threshold && timeSinceLastStep > 500) {
        if (stepCounter < numCalibrationSteps){
          calibrationStepTimes[stepCounter] = millis();
          MIDI.sendNoteOn(2, 50, 1);
          delay(1);
          MIDI.sendNoteOff(2, 50, 1);
          digitalWrite(ledPin, HIGH);
          ledOnTime = millis();
        }
        else{
          for (int i = 1; i < numCalibrationSteps; i++){
            strideFreq += (calibrationStepTimes[i] - calibrationStepTimes[i - 1]);
          }
          strideFreq /= (numCalibrationSteps-1);
          gaitState = stance;
        }
        stepCounter++;
      }
      break;

      
    // instant
    case heelContact:
      // chords
      for (int j = 0; j < notesPerChord; j++){
        MIDI.sendNoteOff(chords[chordCounter][j], 100, 1);
      }
      chordCounter++;
      stepCounter++;
      gaitState = stance;
      break;
      
    case stance:
      // toe off
      if (heelVal < threshold && lastHeelVal > threshold && timeSinceLastTO > 500) {
        gaitState = toeOff;
      }
      
      break;
      
    // instant
    case toeOff:
      lastTOTime = millis();
      gaitState = swingPreKnee;
      break;

    case swingPreKnee:
      gaitState = swingPostKnee;
      break;

    case swingPostKnee:
      // heel contact
      if (heelVal > threshold && lastHeelVal < threshold && timeSinceLastStep > 500) {
        // chords
        for (int j = 0; j < notesPerChord; j++){
          MIDI.sendNoteOn(chords[chordCounter][j], 100, 1);
        }
        gaitState = heelContact;
      }
      break;

    lastHeelVal = heelVal;
  }


  // every loop
  if (millis() - ledOnTime > 50){
    digitalWrite(ledPin, LOW);
  }

  // melody
  if (playMelody){
    if (gaitState != calibration){
      for (int i = 0; i < melodyNotesPerChord; i++){
        if (timeSinceLastStep >= i*strideFreq/melodyNotesPerChord && melodyNotePlayed[i] == false){
          if (melody[chordCounter-1][i] != -1){
            MIDI.sendNoteOn(melody[chordCounter-1][i], 50, 1);
            delay(5);
            MIDI.sendNoteOff(melody[chordCounter-2][i], 50, 1);
          }
          melodyNotePlayed[i] = true;
        }
        else if (timeSinceLastStep < i*strideFreq/melodyNotesPerChord){
          melodyNotePlayed[i] = false;
        }
      }
    }
  }

  // drums
  if (playDrums){
    if (gaitState != calibration){
      // check beat timing
      for (int i = 0; i < drumHitsPerChord; i++){
        if (timeSinceLastStep >= i*strideFreq/drumHitsPerChord && drumHitPlayed[i] == false){
          // check each drum in beat
          for (int j = 0; i < numDrums; i++){
            if (drums[i][j] == 1){
              MIDI.sendNoteOn(j, 50, 1);
              delay(5);
              MIDI.sendNoteOff(j, 50, 1);
            }
            drumHitPlayed[i] = true;
          }
        }
        else if (timeSinceLastStep < i*strideFreq/drumHitsPerChord){
          drumHitPlayed[i] = false;
        }
      }
    }
  }

  timeSinceLastStep = millis() - lastStepTime;

  
  chordCounter %= numChords;

}



void midiRead(){
  
  // Don't continue if we aren't connected.
  if (! Bluefruit.connected()) {
    return;
  }

  // Don't continue if the connected device isn't ready to receive messages.
  if (! blemidi.notifyEnabled()) {
    return;
  }

  // read any new MIDI messages
  MIDI.read();
}

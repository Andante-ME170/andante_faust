
/* For BLE MIDI Setup
   https://learn.adafruit.com/wireless-untztrument-using-ble-midi/overview
*/

#include <bluefruit.h>
#include <MIDI.h>

BLEDis bledis;
BLEMidi blemidi;

// Create a new instance of the Arduino MIDI Library, and attach BluefruitLE MIDI as the transport.
MIDI_CREATE_BLE_INSTANCE(blemidi);


// song bank;
enum songNames {
  CanonInD,
  Mario,
  IWantYouBack,
  ImDifferent,
};

int melody[32][8];
bool melodyNotePlayed[8] = {false,false,false,false,false,false,false,false};;
int melodyNotesPerChord = 8;
int chords[32][3];

// 0 is sustain, -1 is rest

int canonInDMelody [32][8] = {
        {81,  0, 78, 79, 81,  0, 78, 79}, 
        {81, 69, 71, 73, 74, 76, 78, 79}, 
        {78,  0, 74, 76, 78,  0, 66, 67}, 
        {69, 71, 69, 67, 69, 66, 67, 69}, 
        {67,  0, 71, 69, 67,  0, 66, 64}, 
        {66, 64, 62, 64, 66, 67, 69, 71}, 
        {67,  0, 71, 69, 71,  0, 73, 74}, 
        {69, 71, 73, 74, 76, 78, 79, 81},
        
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        };
int canonInDChords[32][3] = {
        {50, 57, 66}, 
        {45, 52, 61}, 
        {47, 54, 62}, 
        {42, 49, 57}, 
        {43, 50, 59}, 
        {50, 57, 66}, 
        {43, 50, 59}, 
        {45, 52, 61},
        
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        };
        
int marioMelody[32][8] = {
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
        {67, -1, -1, -1, 55, -1, -1, -1}
        };
        
int marioChords[32][3] = {
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

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        };


int iWantYouBackMelody[32][8] = {
        {32, -1, -1, -1, -1, -1, -1, -1}, 
        {-1, -1, -1, 34, 36, 39, 41, 37}, 
        {-1, -1, -1, -1, -1, -1, -1, -1}, 
        {-1, 34, 36, 37, -1, 38, 39, 40}, 
        {41,  0,  0,  0, 36,  0,  0,  0}, 
        {37,  0,  0, 32,  0,  0,  0,  0}, 
        {34,  0,  0,  0, 39,  0,  0, 32}, 
        {-1, 27, 29, 32, -1, 29, 32, -1}, 
        
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        
        };
int iWantYouBackChords[32][3] = {
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

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        };

int imDifferentMelody[32][8] = {
        {84,  0,  0,  0,  0,  0, 83,  0}, 
        { 0,  0, 76,  0, 81,  0, 81,  0}, 
        {77,  0,  0,  0,  0,  0,  0,  0}, 
        { 0,  0, 76,  0,  0,  0,  0,  0},
        {84,  0,  0,  0,  0,  0, 83,  0}, 
        { 0,  0, 76,  0, 81,  0, 81,  0}, 
        {77,  0,  0,  0,  0,  0,  0,  0}, 
        { 0,  0, 76,  0,  0,  0,  0,  0},
        
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1},

        
        };

int imDifferentChords[32][3] = {
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1},
        
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1}, 
        {-1, -1, -1},

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},

        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        {-1, -1, -1},
        };


// update w more beats
int drumBeat = 0;
int numDrums;
int drumHitsPerChord;
int drums[8][3];
bool drumHitPlayed[8]  = {false,false,false,false,false,false,false,false};

int beat0[8][3] = {
        {1, 0, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
        {0, 1, 1},
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0}
      };

enum gaitStates {
  calibration,
  stance,
  toeOff,
  swingPreKnee,
  swingPostKnee,
  heelContact,
};


// states
songNames songName = Mario;
gaitStates gaitState = calibration;
bool playMelody = true;
bool playDrums = true;



int notesPerChord;
int numChords;
int lastNotePlayed = -1;
bool secondChordPlayed = false;
int chordsPerStepCycle;



int ledPin = 17;

int heelPin = A1;
int toePin = A2;
int heelVal = 0;
int toeVal = 0;
int lastHeelVal = 0;
int lastToeVal = 0;
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
      notesPerChord = 3;
      numChords = 8;
      melodyNotesPerChord = 8;
      chordsPerStepCycle = 1;
      memcpy(melody, canonInDMelody, sizeof(melody));
      memcpy(chords, canonInDChords, sizeof(chords));
      break;
        
    case Mario:
      notesPerChord = 3;
      numChords = 24;
      melodyNotesPerChord = 8;
      chordsPerStepCycle = 1;
      memcpy(melody, marioMelody, sizeof(melody));
      memcpy(chords, marioChords, sizeof(chords));
      break;
        
    case IWantYouBack:
      notesPerChord = 3;
      numChords = 16;
      melodyNotesPerChord = 8;
      chordsPerStepCycle =  2;
      memcpy(melody, iWantYouBackMelody, sizeof(melody));
      memcpy(chords, iWantYouBackChords, sizeof(chords));
      break;

    case ImDifferent:
      notesPerChord = 3;
      numChords = 16;
      melodyNotesPerChord = 8;
      chordsPerStepCycle = 1;
      memcpy(melody, imDifferentMelody, sizeof(melody));
      memcpy(chords, imDifferentChords, sizeof(chords));
      break;
  }
  
  switch (drumBeat){
    case 0:
      numDrums = 3;
      drumHitsPerChord = melodyNotesPerChord;
      memcpy(drums, beat0, sizeof(drums));
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
  toeVal = analogRead(toePin);
  prevChord = (chordCounter - 1 + numChords) % numChords;


  switch (gaitState) {
    
    case calibration:
      // sense heel contact
      if (heelVal > threshold && lastHeelVal < threshold && timeSinceLastStep > 500) {
        if (stepCounter < numCalibrationSteps){
          calibrationStepTimes[stepCounter] = millis();
          MIDI.sendNoteOn(2, 50, 1);
          digitalWrite(ledPin, HIGH);
          lastStepTime = millis();
          ledOnTime = millis();
        }
        else{
          for (int i = 1; i < numCalibrationSteps; i++){
            strideFreq += (calibrationStepTimes[i] - calibrationStepTimes[i - 1]);
          }
          strideFreq /= (numCalibrationSteps-1);
          gaitState = heelContact;
        }
        stepCounter++;
      }
      break;

      
    // instant
    case heelContact:
      // chords
      for (int j = 0; j < notesPerChord; j++){
        if (chords[chordCounter][j] != -1){
          MIDI.sendNoteOn(chords[chordCounter][j], 100, 1);
        }
      }
      // turn off previous chord
      for (int j = 0; j < notesPerChord; j++){
        if ((chordCounter+numChords-1) % numChords][j] != -1){
          MIDI.sendNoteOff(chords[(chordCounter+numChords-1) % numChords][j], 100, 1);
        }
      }
      digitalWrite(ledPin, HIGH);
      ledOnTime = millis();
      lastStepTime = millis();
      chordCounter++;
      stepCounter++;
      gaitState = stance;
      
      break;
      
    case stance:
      // temporary override
      gaitState = toeOff;
      
      // toe off
      if (toeVal < threshold && lastToeVal > threshold && timeSinceLastTO > 500) {
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
        gaitState = heelContact;
      }
      break;
  }


  // every loop
  if (millis() - ledOnTime > 50){
    digitalWrite(ledPin, LOW);
  }
  lastHeelVal = heelVal;
  
  // melody
  if (playMelody){
    if (gaitState != calibration){
      for (int i = 0; i < melodyNotesPerChord; i++){
        if (timeSinceLastStep >= i*strideFreq/melodyNotesPerChord && !melodyNotePlayed[i]){
          if (melody[(chordCounter+numChords-1) % numChords][i] == -1){
            MIDI.sendNoteOff(lastNotePlayed, 50, 1);
          }
//          else if (melody[(chordCounter+numChords-1) % numChords][i] == 0){
//            // do nothing (sustain)
//          }
          else{
            MIDI.sendNoteOn(melody[(chordCounter+numChords-1) % numChords][i], 50, 1);
            lastNotePlayed = melody[(chordCounter+numChords-1) % numChords][i];
          }
          melodyNotePlayed[i] = true;
        }
        else if (timeSinceLastStep < i*strideFreq/melodyNotesPerChord){
          melodyNotePlayed[i] = false;
        }
      }
    }
  }

  // xtra chords
  if (playMelody && chordsPerStepCycle == 2){
    if (gaitState != calibration){
      if (timeSinceLastStep >= strideFreq/2 && !secondChordPlayed){
        // chords
        for (int j = 0; j < notesPerChord; j++){
          MIDI.sendNoteOn(chords[chordCounter][j], 100, 1);
        }
        // turn off previous chord
        for (int j = 0; j < notesPerChord; j++){
          MIDI.sendNoteOff(chords[(chordCounter+numChords-1) % numChords][j], 100, 1);
        }
        chordCounter++;
        secondChordPlayed = true;
      }
      else if (timeSinceLastStep < strideFreq/2){
        secondChordPlayed = false;
      }
    }
  }

  // drums
  if (playDrums){
    if (gaitState != calibration){
      // check beat timing
      for (int i = 0; i < drumHitsPerChord; i++){
        if (timeSinceLastStep >= i*strideFreq/drumHitsPerChord && !drumHitPlayed[i]){
          // check each drum in beat
          for (int j = 0; i < numDrums; i++){
            if (drums[i][j] == 1){
              MIDI.sendNoteOn(j, 50, 1);
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


/* For BLE MIDI Setup
   https://learn.adafruit.com/wireless-untztrument-using-ble-midi/overview
*/

#include <bluefruit.h>
#include <MIDI.h>

BLEDis bledis;
BLEMidi blemidi;

// Create a new instance of the Arduino MIDI Library, and attach BluefruitLE MIDI as the transport.
MIDI_CREATE_BLE_INSTANCE(blemidi);

// each subarray is a beat; -1 = rest; each note is a 32nd}
const int notesPerChordCanonInD = 3;
const int numChordsCanonInD = 8;
int CanonInDMelody[numChordsCanonInD][8] = {{81, -1, 78, 79, 81, -1, 78, 79}, {81, 69, 71, 73, 74, 76, 78, 79}, {78, -1, 74, 76, 78, -1, 66, 67}, {69, 71, 69, 67, 69, 66, 67, 69}, {67, -1, 71, 69, 67, -1, 66, 64}, {66, 64, 62, 64, 66, 67, 69, 71}, {67, -1, 71, 69, 71, -1, 73, 74}, {69, 71, 73, 74, 76, 78, 79, 81}};
int CanonInDChords[numChordsCanonInD][notesPerChordCanonInD] = {{50,57,66}, {45,52,61}, {47,54,62}, {42,49,57}, {43,50,59}, {50,57,66}, {43,50,59}, {45,52,61}};

bool MelodyNotePlayed[8] = {false,false,false,false,false,false,false,false};

int ledPin = 17;

const int numChords = 8;
const int notesPerChord = 3;    // update manually to match below
int chordMIDIs[numChords][notesPerChord] = {{48,55,64}, {47,52,71}, {45,52,60}, {43,50,58}, {41,48,57}, {40,48,55}, {38,45,53}, {43,50,59}}; // C E Am Gm F C/E Dm G
int drumMIDIs[3] = {0, 1, 2};       // kick, snare, hat
//bool noteStates[6] = {false};     // keep track of the play state of each note


int RHeelPin = A1;
int RHeelVal = 0;
int lastRHeelVal = 0;
int chordCounter = 0;
int prevChord = 0;
int drumCounter = 0;

int stepCounter = 0;
int numCalibrationSteps = 4;
float calibrationStepTimes[] = {0,0,0,0};
float strideFreq = 0;
bool drumSixteenthPlayed[8] = {false,false,false,false,false,false,false,false};

float lastStepTime = 0;
float timeSinceLastStep;


int modPot = 2;  //analog pin A0
int pitchPot = 3;  //analog pin A1
int lastModVal;
int lastPitchVal;

int threshold = 500;

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
  pinMode(17, OUTPUT);  // built-in red LED
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
    stepCounter = 0;
    chordCounter = 0;
    drumCounter = 0;
    strideFreq = 0;
    for (int i = 0; i < numCalibrationSteps; i++){
      calibrationStepTimes[i] = 0;
    }
    return;
  }
  // Don't continue if the connected device isn't ready to receive messages.
  /*  
    
  if (! blemidi.notifyEnabled()) {
    return;
  }
  */

//  //pitchVal = map(pitchVal, 0, 1023, -8000, 8000);
//
//  float modVal;
//  //float  modVal = map(modVal, IMUlow, IMUhi, 1, 100);  // scaling done in app
//  modVal = 40;
//
//  MIDI.sendControlChange(1, modVal, 1);
//
//  //send new mod value if it has changed
//  if (lastModVal != modVal) {
//    Serial.print("modWheel = ");
//    Serial.println(modVal);
//    MIDI.sendControlChange(1, modVal, 1);
//    lastModVal = modVal;
//  }
//
//   //MIDI.sendPitchBend(pitchVal, 1);
  

  RHeelVal = analogRead(RHeelPin);
  drumCounter = chordCounter % 2;
  prevChord = (chordCounter - 1 + numChords) % numChords;

  // clear hanging notes
  if (timeSinceLastStep > strideFreq){
      for (int j = 0; j < notesPerChordCanonInD; j++){
        MIDI.sendNoteOff(CanonInDChords[prevChord][j], 100, 1);
      }
      MIDI.sendNoteOff(CanonInDMelody[prevChord][7], 100, 1);
  }

  // if button pressed
  if (RHeelVal > threshold && lastRHeelVal < threshold && timeSinceLastStep > 500) {
    
    // calibration mode
    if (stepCounter < numCalibrationSteps){
      calibrationStepTimes[stepCounter] = millis();
      MIDI.sendNoteOn(2, 50, 1);
      delay(1);
      MIDI.sendNoteOff(2, 50, 1);
    }

    // active mode
    else{

      lastStepTime = millis();

      if (stepCounter == numCalibrationSteps){
        for (int i = 1; i < numCalibrationSteps; i++){
          strideFreq += (calibrationStepTimes[i] - calibrationStepTimes[i - 1]);
        }
        strideFreq /= (numCalibrationSteps-1);
      }

      
      
      // clear chord
//      for (int i = 0; i < numChords; i++){
//        for (int j = 0; j < notesPerChord; j++){
//          MIDI.sendNoteOff(chordMIDIs[i][j], 100, 1);
//        }
//      }

      // dirty clear all (only works cause I'm not holding chords yet)
//      for (int j = 0; j < 128; j++){
//          MIDI.sendNoteOff(j, 100, 1);
//      }
      
      // trigger notes
      /*
      for (int j = 0; j < notesPerChord; j++){
        MIDI.sendNoteOn(chordMIDIs[chordCounter][j], 100, 1);
        //MIDI.sendNoteOn(83, 100, 1);
        //delay(1);
        MIDI.sendNoteOff(chordMIDIs[prevChord][j], 100, 1);
        //MIDI.sendNoteOff(83, 100, 1);
      }
      */
      
      for (int j = 0; j < notesPerChordCanonInD; j++){
        MIDI.sendNoteOn(CanonInDChords[chordCounter][j], 100, 1);
        //MIDI.sendNoteOn(83, 100, 1);
        delay(1);
        MIDI.sendNoteOff(CanonInDChords[chordCounter-1][j], 100, 1);
        //MIDI.sendNoteOff(83, 100, 1);
      }
      

      chordCounter++;
      
//      // clear drums
//      for (int i = 0; i < sizeof(drumMIDIs); i++){
//        MIDI.sendNoteOff(drumMIDIs[i], 100, 1);
//      }
//      
////      MIDI.sendNoteOn(drumMIDIs[drumCounter], 100, 1);
//      //MIDI.sendNoteOn(drumMIDIs[0], 100, 1);  // snare-only testing mode

  
    }
    
    // verify hardware event detection
    digitalWrite(ledPin, HIGH);
    delay(1);
    
    
    chordCounter %= 8;
    stepCounter++;
  }
  
  else{
    digitalWrite(ledPin, LOW);
  }

  timeSinceLastStep = millis() - lastStepTime;

  
  // drums
  /*
  if (abs(timeSinceLastStep - 0) < 10 && stepCounter >= numCalibrationSteps && drumSixteenthPlayed[0] == false){
    MIDI.sendNoteOn(2, 50, 1);
    //MIDI.sendNoteOn(3, 50, 1);
    delay(15);
    MIDI.sendNoteOff(2, 50, 1);
    //MIDI.sendNoteOff(3, 50, 1);
    drumSixteenthPlayed[0] = true;
  }
  else{
    drumSixteenthPlayed[0] = false;
  }
  
  if (abs(timeSinceLastStep - strideFreq/4) < 10 && stepCounter >= numCalibrationSteps && drumSixteenthPlayed[2] == false){
    MIDI.sendNoteOn(2, 50, 1);
    delay(15);
    MIDI.sendNoteOff(2, 50, 1);
    drumSixteenthPlayed[2] = true;
  }
    else{
    drumSixteenthPlayed[2] = false;
  }
  if (abs(timeSinceLastStep - strideFreq/2) < 10 && stepCounter >= numCalibrationSteps && drumSixteenthPlayed[4] == false){
    MIDI.sendNoteOn(2, 50, 1);
    MIDI.sendNoteOn(1, 50, 1);
    delay(15);
    MIDI.sendNoteOff(2, 50, 1);
    MIDI.sendNoteOff(1, 50, 1);
    drumSixteenthPlayed[4] = true;
  }
    else{
    drumSixteenthPlayed[4] = false;
  }
  
  if (abs(timeSinceLastStep - 3*strideFreq/4) < 10 && stepCounter >= numCalibrationSteps && drumSixteenthPlayed[6] == false){
    MIDI.sendNoteOn(2, 50, 1);
    delay(15);
    MIDI.sendNoteOff(2, 50, 1);
    drumSixteenthPlayed[6] = true;
  }
    else{
    drumSixteenthPlayed[6] = false;
  }
  

  // kick on the 'a' (every other time)
//  if (abs(timeSinceLastStep - 7*strideFreq/8) < 10 && stepCounter >= numCalibrationSteps && drumSixteenthPlayed[7] == false && chordCounter%2 == 0){
//    MIDI.sendNoteOn(3, 50, 1);
//    delay(15);
//    MIDI.sendNoteOff(3, 50, 1);
//    drumSixteenthPlayed[7] = true;
//  }
//    else{
//    drumSixteenthPlayed[7] = false;
//  }

  // play melody
*/


  if (stepCounter >= numCalibrationSteps){
    for (int i = 0; i < 8; i++){
      if (abs(timeSinceLastStep - i*strideFreq/8) < 10 && MelodyNotePlayed[i] == false){
        if (CanonInDMelody[chordCounter-1][i] != -1){
          MIDI.sendNoteOn(CanonInDMelody[chordCounter-1][i], 50, 1);
          delay(5);
          MIDI.sendNoteOff(CanonInDMelody[chordCounter-2][i], 50, 1);
        }
        MelodyNotePlayed[i] = true;
      }
      else{
        MelodyNotePlayed[i] = false;
      }
    }
  }


  lastRHeelVal = RHeelVal;
  delay(5);
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

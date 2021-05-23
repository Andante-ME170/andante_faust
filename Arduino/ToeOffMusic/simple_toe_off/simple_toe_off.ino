#include <bluefruit.h>
#include <MIDI.h>

BLEDis bledis;
BLEMidi blemidi;
// Create a new instance of the Arduino MIDI Library, and attach BluefruitLE MIDI as the transport.
MIDI_CREATE_BLE_INSTANCE(blemidi);
const uint8_t ledPin = 17;
const char *deviceName = "Bluefruit52 MIDI foot";

const uint8_t fsrPinToe = 30;
const int toeThreshold = 375;  // depends on each FSR
const uint8_t fsrPinHeel = 30;  // using the same fsr for testing
const int heelThreshold = 375;   // again, using same fsr for testing
const int hysteresis = 100;
float stepTimeThreshold = 500;

const int SIZE_AVG = 4;
int toeAvg[SIZE_AVG];
int heelAvg[SIZE_AVG];
int avgIdx = 0;

int tonic = 0;
int majorSteps[8] = {0,2,4,5,7,9,11,12};  // distance of each note from tonic (half steps)
float lastStepTime = 0;
const int calibrationInt = 103;

enum States {
  TOE_OFF,
  HEEL_STRIKE,
};

States state = TOE_OFF;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(fsrPinToe, INPUT);
  pinMode(fsrPinHeel, INPUT);
  for (int i = 0; i < SIZE_AVG; i++) {
    toeAvg[i] = analogRead(fsrPinToe);
    heelAvg[i] = analogRead(fsrPinHeel);
  }
  setupBLE();
}

void loop() {
  // Don't continue if we aren't connected.
  if (! Bluefruit.connected()) {
    return;
  }
  
  int fsrValHeel, fsrValToe;
  updateMovingAverages(fsrValHeel, fsrValToe);
  
  //Serial.println(fsrValToe > toeThreshold ? "ground contact" : "toe off");
  
  float currTime = millis();
    
  switch (state) {
    case TOE_OFF:
    {     
      if (fsrValHeel > heelThreshold + hysteresis && currTime - lastStepTime > stepTimeThreshold) {
        state = HEEL_STRIKE;
        Serial.println("Heel strike");
        lastStepTime = currTime;     
        MIDI.sendNoteOff(tonic, calibrationInt, 1);   
      }
      break;
    }
    case HEEL_STRIKE:
    {
      
      if (fsrValToe < toeThreshold - hysteresis && fsrValHeel < heelThreshold - hysteresis) {
        MIDI.sendNoteOn(tonic, calibrationInt, 1);
        Serial.println("Toe Off");
        state = TOE_OFF;
      }
      
      break;
    }
    default:
      Serial.println("Shouldn't be stateless :(");
      break;
  }
}

void setupBLE() {
  Serial.println("Adafruit Bluefruit52 MIDI over Bluetooth LE Example");

  // Config the peripheral connection with maximum bandwidth
  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  Bluefruit.begin();
  Bluefruit.setName(deviceName);
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
  
  pinMode(ledPin, OUTPUT);
}

void updateMovingAverages(int &fsrValHeel, int &fsrValToe) {
  toeAvg[avgIdx] = analogRead(fsrPinToe);
  heelAvg[avgIdx] = analogRead(fsrPinHeel);
  avgIdx = (avgIdx + 1) % SIZE_AVG;
  fsrValHeel = 0;
  fsrValToe = 0;
  for (int i = 0; i < SIZE_AVG; i++) {
    fsrValHeel += heelAvg[i];
    fsrValToe += toeAvg[i];
  }
  fsrValHeel /= SIZE_AVG;
  fsrValToe /= SIZE_AVG;
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

  // Start Advertising
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

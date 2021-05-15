//
//  ViewController.m
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

#import "ViewController.h"
#import "DspFaust.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController3.h"

NSLock *theLock  = [[NSLock alloc] init];

NSMutableArray *soundOn = [[NSMutableArray alloc]init];

int prevGenre = 0;
                         

@interface ViewController ()<AVAudioPlayerDelegate>

//https://developer.apple.com/documentation/avfaudio/avaudioplayer

@property (nonatomic, strong) NSString *bleDevice;
@property (nonatomic, strong) NSMutableArray *pickerData;
@property (nonatomic, strong) NSMutableArray *devices;
@property CBCentralManager *myManager;

@property (weak, nonatomic) IBOutlet UILabel *currInstrumentTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

// Trap
@property(nonatomic,strong)AVAudioPlayer *kickAP;
@property(nonatomic,strong)AVAudioPlayer *snareAP;
@property(nonatomic,strong)AVAudioPlayer *hatAP;
//@property(nonatomic,strong)NSTimer *timer; not using rn

// Random Sounds
@property(nonatomic,strong)AVAudioPlayer *carAP;
@property(nonatomic,strong)AVAudioPlayer *telephoneAP;

// Songs
@property(nonatomic,strong)AVAudioPlayer *walkSunshineAP;
@property(nonatomic,strong)AVAudioPlayer *funkyAP;

// Ya messed up!
@property(nonatomic,strong)AVAudioPlayer *noAP;


// More genres here!

@end

@implementation ViewController{
  DspFaust *dspFaust;
}


// Trap
@synthesize kickAP = kick;
@synthesize snareAP = snare;
@synthesize hatAP = hat;

// Random Sounds
@synthesize carAP = car;
@synthesize telephoneAP = phone;

// Songs
@synthesize walkSunshineAP = sunshine;
@synthesize funkyAP = funky;

// Ya messed up!
@synthesize noAP = no;

// Insert more genres


int chordCounter = 0;
int chordMIDIs[4][6] = {{48,55,60,64,60,55}, {43,50,55,59,55,50}, {45,52,57,60,57,52}, {41,48,53,57,53,48}}; // C G Am F
int notesPerChord = 6;    // update manually to match above
int currentArpNote = 0;
int kneeRanges[5] = {60,50,30,50,60};  // calibrate
int lastKneeVal = 0;
int prevArpNote = 0;   // weird workaround for starting at zero and not wanting to get a neg index error
float currentDetune = 0.0f;
float detuneAmount = 0.0f;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    const int SR = 44100;
    const int bufferSize = 256;

       
     dspFaust = new DspFaust(SR,bufferSize);
     dspFaust->start();
    
    _myManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    NSDictionary *option = @{
        CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:YES]
    };
    [_myManager scanForPeripheralsWithServices:nil options:option];
    
    // Initialize picker view
    _pickerData = [[NSMutableArray alloc]init];
    [_pickerData addObject:@"BLE music devices:"];
    _bleDevice = [[NSString alloc]init];
    _devices = [[NSMutableArray alloc]init];
     
    // Connect data
    _picker.dataSource = self;
    _picker.delegate = self;
    
    
    // For SoundFonts
    NSError *error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"smooth kick 1" withExtension:@ "wav"];
 //   NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"trap snare 1" withExtension:@ "wav"];
    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"basic hat" withExtension:@ "wav"];
    kick = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    snare = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    hat = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
    [kick prepareToPlay]; // function call
  //  [snare prepareToPlay];
    [hat prepareToPlay];
    
    // Random Sounds
    NSURL *url_RS_1 = [[NSBundle mainBundle] URLForResource:@"Car" withExtension:@ "wav"];
    car = [[AVAudioPlayer alloc] initWithContentsOfURL:url_RS_1 error:&error];
    [car prepareToPlay];
    
    NSURL *url_RS_2 = [[NSBundle mainBundle] URLForResource:@"Telephone" withExtension:@ "wav"];
    phone = [[AVAudioPlayer alloc] initWithContentsOfURL:url_RS_2 error:&error];
    [phone prepareToPlay];
    
    
    // Songs
    NSURL *url_S_1 = [[NSBundle mainBundle] URLForResource:@"WalkingOnSunshine" withExtension:@ "wav"];
    sunshine = [[AVAudioPlayer alloc] initWithContentsOfURL:url_S_1 error:&error];
    [sunshine prepareToPlay];
    
    NSURL *url_S_2 = [[NSBundle mainBundle] URLForResource:@"FUNKY_HOUSE" withExtension:@ "mp3"];
    funky = [[AVAudioPlayer alloc] initWithContentsOfURL:url_S_2 error:&error];
    [funky prepareToPlay];

    // More gengres here
    
    NSURL *url_no = [[NSBundle mainBundle] URLForResource:@"please-no" withExtension:@ "mp3"];
    no = [[AVAudioPlayer alloc] initWithContentsOfURL:url_no error:&error];
    [no prepareToPlay];
    

    /*
    // Moved below to button press area rather than here
    // Added below, modeled off of (https://ccrma.stanford.edu/~rmichon/faustTutorials/#adding-faust-real-time-audio-support-to-ios-apps)
     
    const int SR = 44100;
    const int bufferSize = 256;
                      
    dspFaust = new DspFaust(SR,bufferSize);
    dspFaust->start();
    dspFaust->setParamValue("/synth/gate", 1);
    //dspFaust->setParamValue(3, 1);*/
     
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
     return 1;
 }

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
 {
     return _pickerData.count;
 }

// The data to return for the row and component (column) that's being passed in
 - (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
     return _pickerData[row];
 }

// Do something with the selected row
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _bleDevice = [_pickerData objectAtIndex: row];
    NSLog(@"You selected this: %@", _bleDevice);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self beginSearching];
}

- (void)beginSearching {
    switch ([_myManager state]) {
        case CBManagerStateUnsupported:
            NSLog(@"The platform/hardware doesn't support BLE.");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"The app isn't authorized to use BLE.");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"Bluetooth currently powered off");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"powered On");
            [_myManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBManagerStateUnknown:
            NSLog(@"update");
            break;
        default:
            NSLog(@"everything is broken :(");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    if ([peripheral.name length] != 0) {
        NSLog(@"<%@>", peripheral.name);
        
        if ([peripheral.name containsString:@"Bluefruit"]) {
            [_devices addObject:peripheral];
            [_pickerData addObject: peripheral.name];
            [_picker reloadAllComponents];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    for (int i = 0; i < [_pickerData count]; i++) {
        if ([[_pickerData objectAtIndex:i] isEqualToString:peripheral.name]) {
            [_pickerData removeObject:peripheral.name];
            [_picker reloadAllComponents];
            [_currInstrumentTextField setHidden:YES];
            [_devices removeObject:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"<%@>", service.UUID.UUIDString);
        if ([service.UUID.UUIDString isEqualToString:@"03B80E5A-EDE8-4B33-A751-6CE34EC4C700"]) {
            NSLog(@"BLE MIDI!");
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString containsString:@"7772E5DB-3868-4112-A1A9-F2669D106BF3"]) {
            
            NSLog(@"Got characteristics!");
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
            
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"reading value!");
    NSLog(@"<%@>", characteristic.value);
    
    NSData *rawData = characteristic.value;
    
    
    // for MIDI specifically
    long longVal;
    [rawData getBytes:&longVal length:sizeof(longVal)];
    int intVal = (int)(longVal >> 16);
    int mask[3] = {0xff0000, 0xff00, 0xff};
    int vals[3] = {(intVal & mask[0]) >> 16, (intVal & mask[1]) >> 8, intVal & mask[2]};
//    NSLog(@"MIDI int #1: %d", vals[0]);
//    NSLog(@"MIDI int #2: %d", vals[1]);
//    NSLog(@"MIDI int #3: %d", vals[2]);
    
    if ([theLock tryLock]) {
        
        // Music code!
        
        // footswitch + knee brace (or just footswitch), chords+drums+detune
        
        // initial parameters (do elsewhere?)
        dspFaust->setParamValue("hat_gain", .8);
        dspFaust->setParamValue("snare_gain", .9);
        dspFaust->setParamValue("kick_gain", .9);
        //dspFaust->setParamValue("kick_freq", 100);
        //dspFaust->setParamValue("detune", 0.5);
        dspFaust->setParamValue("kick_gate", 0);
        dspFaust->setParamValue("detune", detuneAmount);
        
        if ([peripheral.name containsString:@"Bluefruit52 MIDI 2"]) {
            // Control changes
            if (vals[2] == 176){
             //   currentDetune = vals[0]/100.0f; // Melissa: maybe change denom to be slider value?
                currentDetune = vals[0]/globalMaxDetune; // Melissa: check this
                detuneAmount = currentDetune;
            }
        }
        else if ([peripheral.name containsString:@"Bluefruit52 MIDI"]) {
            // Play music
            // noteOn
            if (vals[2] == 144){
                // drums
                if (vals[1] == 3){
                    //dspFaust->setParamValue("kick_gate", 1);
                    kick.currentTime = 0;
                    [kick play];
                }
                else if (vals[1] == 1){
                    //dspFaust->setParamValue("snare_gate", 1);
                    snare.currentTime = 0;
                    [snare play];
                }
                else if (vals[1] == 2){
                    //dspFaust->setParamValue("hat_gate", 1);
                    hat.currentTime = 0;
                    [hat play];
                }
                
                // chord synth
                else{
                    dspFaust->keyOn(vals[1], vals[0]);
                }
                //NSLog(@"MIDI int #2: %d", vals[1]);
                
                // dspFaust->setParamValue("synth_midi", vals[1]);
                // dspFaust->setParamValue("synth_gate", 1);
                
                // implement velocity -> gain later
            }

            // noteOff
            if (vals[2] == 128){
                // drums
                if (vals[1] == 3){
                    //dspFaust->setParamValue("kick_gate", 0);
                    [kick pause];
                }
                else if (vals[1] == 1){
                    dspFaust->setParamValue("snare_gate", 0);
                    [snare pause];
                }
                else if (vals[1] == 2){
                    dspFaust->setParamValue("hat_gate", 0);
                    [hat pause];
                }
                
                // chord synth
                else{
                    dspFaust->keyOff(vals[1]);
                    }
                // dspFaust->setParamValue("synth_midi", vals[1]);
                // dspFaust->setParamValue("synth_gate", 0);
                // problematic; shuts all off if one key is off; learn multi-channel midi later
                }
            }

        
        
        // footswitch + knee brace (or just footswitch), arpeggios
        /*
        chordCounter %= 4;
        currentArpNote %= 6;
        
        if ([peripheral.name containsString:@"Bluefruit52 MIDI 2"]) {
            // Control changes
            if (vals[2] == 176){
                if (currentArpNote < 4 && currentArpNote > 0){
                    if (vals[0] < kneeRanges[currentArpNote-1] && lastKneeVal >= kneeRanges[currentArpNote-1]){
                        dspFaust->keyOn(chordMIDIs[chordCounter][currentArpNote], 100);
                        // turn off previous note
                        dspFaust->keyOff(chordMIDIs[chordCounter][prevArpNote]);
                        prevArpNote = currentArpNote;
                        currentArpNote++;
                    }
                    lastKneeVal = vals[0];
                }
                else{
                    if (vals[0] > kneeRanges[currentArpNote-1] && lastKneeVal <= kneeRanges[currentArpNote-1]){
                        dspFaust->keyOn(chordMIDIs[chordCounter][currentArpNote], 100);
                        // turn off previous note
                        dspFaust->keyOff(chordMIDIs[chordCounter][prevArpNote]);
                        prevArpNote = currentArpNote;
                        currentArpNote++;
                    }
                    lastKneeVal = vals[0];
                }
                
            }
            else if (vals[2] == 128){
                dspFaust->keyOff(vals[1]);
            }
        }
        else if ([peripheral.name containsString:@"Bluefruit52 MIDI"]) {

            // noteOn
            if (vals[2] == 144){
                // drums
                if (vals[1] == 0){
                    for (int i = 0; i < 4; i++){
                        dspFaust->keyOff(chordMIDIs[chordCounter][i]);
                    }
                    chordCounter++;
                    dspFaust->keyOn(chordMIDIs[chordCounter][0], 100);
                    prevArpNote = currentArpNote;
                    currentArpNote++;
                    
                }
            }
        }
        */
        [theLock unlock];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)connectWasPressed:(id)sender {
    for (int i = 0; i < [_devices count]; i++) {
        CBPeripheral *peripheral = [_devices objectAtIndex:i];
        if ([peripheral.name isEqualToString:_bleDevice]) {
            [_myManager connectPeripheral:peripheral options:nil];
            [_currInstrumentTextField setText:[@"Connected: " stringByAppendingString:_bleDevice]];
            [_currInstrumentTextField setHidden:NO];
        }
    }
}

//- (void)playFromBegin:(AVAudioPlayer)ap {
 //   ap.currentTime = 0;
  //  [ap play];
//}

/*
// Button Click Event
- (void)audioPlay{
   if (!_audioPlayer.isPlaying) {
        [self startPlay];
   }else{
       [self stopPlay];
    }
}

// Start playing
- (void)startPlay {
    [_audioPlayer play];
    [_audioPlayer2 play]; //added
    if ( !self.timer ) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        }];
    }
}

//Stop playing
- (void)stopPlay{
   [_audioPlayer pause];
   [_audioPlayer2 pause];
    _audioPlayer.currentTime = 0;
    _audioPlayer2.currentTime = 0;
}
*/
- (IBAction)buttonPressed:(id)sender {
    if (prevGenre != Globalgenre) {
        [self turnOff]; // reset sounds
        [no stop]; // stop Michael Scott, Melissa delete later
    }
    if (Globalgenre == 1) { // Trap
        [self genreTrap];
        prevGenre = 1;
      //  [kick play];
    }
    else if (Globalgenre == 2) { // RandomSongs
        [self genreRS];
        prevGenre = 2;
       // [phone play];
    }
    else if (Globalgenre == 3) { // Songs
        [self genreSongs];
        prevGenre = 3;
       // [sunshine play];
    }
    else { // pick a genre
        [self noAP];
        [no play];
    }
    
    //else {
      //  [self walkSunshineAP];
       // [sunshine play];
    //}
        
        // [self kickAP];
       //  [kick play];
       //  [self hatAP];
       //  [hat play];) {

    
    //[self kickAP];
    //[kick play];
    //if (!_audioPlayer.isPlaying) {//} && !_playButton.selected ) {
      //  [self startPlay];
     //   [_audioPlayer play];
     //   [_audioPlayer2 play];
  //  }
   // else { // pause if button is pressed while music is already playing
      //  [_audioPlayer pause];
      //  [_audioPlayer2 pause];
   // }
}
- (IBAction)Genre:(id)sender {
    [self turnOff];
}

-(void)turnOff {
    for(id tempObject in soundOn) { // loop through every element in the array
        [tempObject stop]; // change to stop later...
  //      NSLog(@"Single element: %@", tempObject);
    }
}

-(void)genreTrap {
   // [soundOn removeAllObjects];
    [self kickAP];
    [kick play];
    [self hatAP];
    [hat play];
    
    if (![soundOn containsObject:kick]) { // should already be empty?
        [soundOn addObject:kick]; // adds objects to array
    }
    if (![soundOn containsObject:hat]) {
        [soundOn addObject:hat]; // adds objects to array
    }
}

-(void)genreRS {
    [self telephoneAP];
    [phone play];
    [self carAP];
    //[car play];
    if (![soundOn containsObject:phone]) {
        [soundOn addObject:phone]; // adds objects to array
    }
   // if (![soundOn containsObject:@"car"]) {
   //     [soundOn addObject:@"car"]; // adds objects to array
    //}
}

-(void)genreSongs {
   // [phone stop]; // need to do this for all of them.....
  //  [car stop];
  //  [kick stop];
  //  [hat stop];
    [self walkSunshineAP];
    [sunshine play];
    if (![soundOn containsObject:sunshine]) {
        [soundOn addObject:sunshine]; // adds objects to array
    }
}





    
    // your code here
    // play Faust music
    
    /* Added below, modeled off of (https://ccrma.stanford.edu/~rmichon/faustTutorials/#adding-faust-real-time-audio-support-to-ios-apps)
     */
    //const int SR = 44100;
    //const int bufferSize = 256;
                      
    //dspFaust = new DspFaust(SR,bufferSize);
    // dspFaust->start();
    //dspFaust->setParamValue("/synth/gate", 1);
    //dspFaust->setParamValue(3, 1); // in example, this line was commented out and above line was include, try this again after other fixes
//}

// Added below method
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // added for SoundFonts
                                    
    // dspFaust->stop();
    // delete dspFaust;
}

@end

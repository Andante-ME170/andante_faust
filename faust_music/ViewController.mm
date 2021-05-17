//
//  ViewController.m
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

// Melissa: changed file extension to .mm, think this is allowed and will work
// Implemented Faust object

#import "ViewController.h"
#import "DspFaust.h"

#define HEEL_STRIKE         0       // tonic (do)
#define TOE_OFF             9       // submediant (la)
#define NUM_FIFTHS          12
#define KNEE_DIFF_THRESH    30

NSLock *theLock = [[NSLock alloc] init];

@interface ViewController ()

@property (nonatomic, strong) NSString *midiServiceUUID;
@property (nonatomic, strong) NSString *midiCharUUID;

@property (nonatomic, strong) NSString *bleDevice;
@property (nonatomic, strong) NSMutableArray *pickerData;
@property (nonatomic, strong) NSMutableArray *devices;
@property CBCentralManager *myManager;

@property (weak, nonatomic) IBOutlet UILabel *currInstrumentTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation ViewController{
    DspFaust *dspFaust;
    int state;
    int circleOf5ths[NUM_FIFTHS];
    int tonicIdx;
    int kneeStanceAvg;
    int numStanceAvg;
    bool tonicChange;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    state = TOE_OFF;
    int co5[NUM_FIFTHS] = {48,55,50,57,52,59,54,49,56,51,58,53};
    memcpy(circleOf5ths, co5, sizeof(co5));
    tonicIdx = 0;
    kneeStanceAvg = 0;
    numStanceAvg = 0;
    tonicChange = false;
    
    _midiCharUUID = @"7772E5DB-3868-4112-A1A9-F2669D106BF3";
    _midiServiceUUID = @"03B80E5A-EDE8-4B33-A751-6CE34EC4C700";
    
    
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
        if ([service.UUID.UUIDString isEqualToString:_midiServiceUUID]) {
            NSLog(@"BLE MIDI!");
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString containsString:_midiCharUUID]) {
            
            NSLog(@"Got characteristics!");
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];

        }
    }
}



- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //NSLog(@"reading value!");
    //NSLog(@"<%@>", characteristic.value);
    
    NSData *rawData = characteristic.value;
    
    
    // for MIDI specifically
    long longVal;
    [rawData getBytes:&longVal length:sizeof(longVal)];
    int intVal = (int)(longVal >> 16);
    int mask[3] = {0xff0000, 0xff00, 0xff};
    int vals[3] = {(intVal & mask[0]) >> 16, (intVal & mask[1]) >> 8, intVal & mask[2]};
    //NSLog(@"MIDI int #1: %d", vals[0]);
    //NSLog(@"MIDI int #2: %d", vals[1]);
    //NSLog(@"MIDI int #3: %d", vals[2]);
    
    // Play music
    
    switch (state) {
        case TOE_OFF:
        {
            // swing phase
            if ([peripheral.name containsString:@"Bluefruit52 MIDI knee"]) {
                if (vals[1] >= kneeStanceAvg + KNEE_DIFF_THRESH) {
                    tonicChange = true;
                }
                NSLog(@"Knee angle = %d", vals[1]);
                NSLog(@"kneeStanceAvg = %d", kneeStanceAvg);
            } else if ([peripheral.name containsString:@"Bluefruit52 MIDI foot"]) {
                if (vals[1] == HEEL_STRIKE) {
                    state = HEEL_STRIKE;
                    kneeStanceAvg = 0;
                    numStanceAvg = 0;
                    if (tonicChange) {
                        tonicIdx = (tonicIdx + 1) % NUM_FIFTHS;
                    }
                    tonicChange = false;
                }
            }
            break;
        }
        case HEEL_STRIKE:
        {
            // stance phase
            if ([peripheral.name containsString:@"Bluefruit52 MIDI knee"]) {
                kneeStanceAvg += vals[1];
                numStanceAvg++;
            } else if ([peripheral.name containsString:@"Bluefruit52 MIDI foot"]) {
                if (vals[1] == TOE_OFF) {
                    state = TOE_OFF;
                    kneeStanceAvg /= numStanceAvg;
                }
            }
            break;
        }
    }

    [theLock lock];
    if ([peripheral.name containsString:@"Bluefruit52 MIDI foot"] && vals[2] == 144){
        dspFaust->keyOn(circleOf5ths[tonicIdx] + vals[1], vals[0]);
        NSLog(@"MIDI int: %d", vals[1]);
    }
    else if ([peripheral.name containsString:@"Bluefruit52 MIDI foot"] && vals[2] == 128){
        dspFaust->keyOff(circleOf5ths[tonicIdx] + vals[1]);
    }
    [theLock unlock];

     
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// Added below method
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
                                    
    // dspFaust->stop();
    // delete dspFaust;
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

- (IBAction)buttonPressed:(id)sender {
    // your code here
    
    // send BLE signal to nRF52
    for (int i = 0; i < [_devices count]; i++) {
        CBPeripheral *device = [_devices objectAtIndex:i];
        if ([device.name containsString:@"Bluefruit"]) {
            for (CBService *service in device.services) {
                if ([service.UUID.UUIDString isEqualToString:_midiServiceUUID]) {
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID.UUIDString containsString:_midiCharUUID]) {
                            NSLog(@"BLE MIDI!");
                            int intVal = (100 << 16) + (101 << 8) + 102;
                            NSData *data = [NSData dataWithBytes: &intVal length: sizeof(intVal)];
                            NSLog(@"<%@>", data);
                            [device writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
    }
    
    
    /* Added below, modeled off of (https://ccrma.stanford.edu/~rmichon/faustTutorials/#adding-faust-real-time-audio-support-to-ios-apps)
     */
    //const int SR = 44100;
    //const int bufferSize = 256;
                      
    //dspFaust = new DspFaust(SR,bufferSize);
    // dspFaust->start();
    //dspFaust->setParamValue("/synth/gate", 1);
    //dspFaust->setParamValue(3, 1); // in example, this line was commented out and above line was include, try this again after other fixes
}

@end

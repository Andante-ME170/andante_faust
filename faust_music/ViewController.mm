//
//  ViewController.m
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

#import "ViewController.h"
#import "DspFaust.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController2.h"
#import "ViewController3.h"
#import <stdarg.h>

NSLock *theLock  = [[NSLock alloc] init];

NSMutableArray *soundOn = [[NSMutableArray alloc]init];
NSMutableArray *randomSoundsArray = [[NSMutableArray alloc]init];
NSMutableArray *randomSoundsArrayAP = [[NSMutableArray alloc]init];
NSMutableArray *Piano = [[NSMutableArray alloc]init];


int prevGenre = -1;
                         
@interface ViewController ()<AVAudioPlayerDelegate>


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
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;


// Piano
@property(nonatomic,strong)AVAudioPlayer *APPiano32;
@property(nonatomic,strong)AVAudioPlayer *APPiano33;
@property(nonatomic,strong)AVAudioPlayer *APPiano34;
@property(nonatomic,strong)AVAudioPlayer *APPiano35;
@property(nonatomic,strong)AVAudioPlayer *APPiano36;
@property(nonatomic,strong)AVAudioPlayer *APPiano37;
@property(nonatomic,strong)AVAudioPlayer *APPiano38;
@property(nonatomic,strong)AVAudioPlayer *APPiano39;
@property(nonatomic,strong)AVAudioPlayer *APPiano40;
@property(nonatomic,strong)AVAudioPlayer *APPiano41;
@property(nonatomic,strong)AVAudioPlayer *APPiano42;
@property(nonatomic,strong)AVAudioPlayer *APPiano43;
//@property(nonatomic,strong)AVAudioPlayer *APPiano44;
//@property(nonatomic,strong)AVAudioPlayer *APPiano45;
//@property(nonatomic,strong)AVAudioPlayer *APPiano46;
//@property(nonatomic,strong)AVAudioPlayer *APPiano47;
@property(nonatomic,strong)AVAudioPlayer *APPiano48;
@property(nonatomic,strong)AVAudioPlayer *APPiano49;
@property(nonatomic,strong)AVAudioPlayer *APPiano50;
@property(nonatomic,strong)AVAudioPlayer *APPiano51;
@property(nonatomic,strong)AVAudioPlayer *APPiano52;
@property(nonatomic,strong)AVAudioPlayer *APPiano53;
@property(nonatomic,strong)AVAudioPlayer *APPiano54;
@property(nonatomic,strong)AVAudioPlayer *APPiano55;
//@property(nonatomic,strong)AVAudioPlayer *APPiano56;
@property(nonatomic,strong)AVAudioPlayer *APPiano57;
@property(nonatomic,strong)AVAudioPlayer *APPiano58;
@property(nonatomic,strong)AVAudioPlayer *APPiano59;
@property(nonatomic,strong)AVAudioPlayer *APPiano60;
@property(nonatomic,strong)AVAudioPlayer *APPiano61;
@property(nonatomic,strong)AVAudioPlayer *APPiano62;
@property(nonatomic,strong)AVAudioPlayer *APPiano63;
@property(nonatomic,strong)AVAudioPlayer *APPiano64;
@property(nonatomic,strong)AVAudioPlayer *APPiano65;
@property(nonatomic,strong)AVAudioPlayer *APPiano66;
@property(nonatomic,strong)AVAudioPlayer *APPiano67;
@property(nonatomic,strong)AVAudioPlayer *APPiano68;
@property(nonatomic,strong)AVAudioPlayer *APPiano69;
@property(nonatomic,strong)AVAudioPlayer *APPiano70;
@property(nonatomic,strong)AVAudioPlayer *APPiano71;
@property(nonatomic,strong)AVAudioPlayer *APPiano72;
@property(nonatomic,strong)AVAudioPlayer *APPiano73;
@property(nonatomic,strong)AVAudioPlayer *APPiano74;
@property(nonatomic,strong)AVAudioPlayer *APPiano75;
@property(nonatomic,strong)AVAudioPlayer *APPiano76;
@property(nonatomic,strong)AVAudioPlayer *APPiano77;
@property(nonatomic,strong)AVAudioPlayer *APPiano78;
@property(nonatomic,strong)AVAudioPlayer *APPiano79;
@property(nonatomic,strong)AVAudioPlayer *APPiano80;

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

@synthesize audioPlayer = audioPlayer2;
// Ya messed up!
//@synthesize noAP = no;

// Insert more genres
@synthesize APPiano32 = Piano32;
@synthesize APPiano33 =  Piano33;
@synthesize APPiano34 = Piano34;
@synthesize APPiano35 = Piano35;
@synthesize APPiano36 = Piano36;
@synthesize APPiano37 = Piano37;
@synthesize APPiano38 = Piano38;
@synthesize APPiano39 = Piano39;
@synthesize APPiano40 = Piano40;
@synthesize APPiano41 = Piano41;
@synthesize APPiano42 = Piano42;
@synthesize APPiano43 =  Piano43;
//@synthesize APPiano44 = Piano44;
//@synthesize APPiano45 = Piano45;
//@synthesize APPiano46 = Piano46;
//@synthesize APPiano47 = Piano47;
@synthesize APPiano48 = Piano48;
@synthesize APPiano49 = Piano49;
@synthesize APPiano50 = Piano50;
@synthesize APPiano51 = Piano51;
@synthesize APPiano52 = Piano52;
@synthesize APPiano53 = Piano53;
@synthesize APPiano54 = Piano54;
@synthesize APPiano55 = Piano55;
//@synthesize APPiano56 = Piano56;
@synthesize APPiano57 = Piano57;
@synthesize APPiano58 = Piano58;
@synthesize APPiano59 = Piano59;
@synthesize APPiano60 = Piano60;
@synthesize APPiano61 = Piano61;
@synthesize APPiano62 = Piano62;
@synthesize APPiano63 = Piano63;
@synthesize APPiano64 = Piano64;
@synthesize APPiano65 = Piano65;
@synthesize APPiano66 = Piano66;
@synthesize APPiano67 = Piano67;
@synthesize APPiano68 = Piano68;
@synthesize APPiano69 = Piano69;
@synthesize APPiano70 = Piano70;
@synthesize APPiano71 = Piano71;
@synthesize APPiano72 = Piano72;
@synthesize APPiano73 = Piano73;
@synthesize APPiano74 = Piano74;
@synthesize APPiano75 = Piano75;
@synthesize APPiano76 = Piano76;
@synthesize APPiano77 = Piano77;
@synthesize APPiano78 = Piano78;
@synthesize APPiano79 = Piano79;
@synthesize APPiano80 = Piano80;


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
   // NSURL *url = [[NSBundle mainBundle] URLForResource:@"smooth kick 1" withExtension:@ "wav"];
    kick = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"smooth kick 1" withExtension:@ "wav"] error:&error];
    hat = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"basic hat" withExtension:@ "wav"] error:&error];
    [kick prepareToPlay]; // function call

    [hat prepareToPlay];
    
    // Random Sounds
    car = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Car" withExtension:@ "wav"] error:&error];
    [car prepareToPlay];
    
    phone = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Telephone" withExtension:@ "wav"] error:&error];
    [phone prepareToPlay];
    [randomSoundsArray addObject:car];
    [randomSoundsArray addObject:phone];
    
    // Songs
    sunshine = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"WalkingOnSunshine" withExtension:@ "wav"] error:&error];
    [sunshine prepareToPlay];
    
    funky = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"FUNKY_HOUSE" withExtension:@ "mp3"] error:&error];
    [funky prepareToPlay];

    // More gengres here

    
    switch(Globalgenre) {
            case -1:
                self.genreValue.text = @"Current: Not set";
                break;
            case 0:
                self.genreValue.text = @"Current: Minor Chord";
                break;
            case 1:
                self.genreValue.text = @"Random Sounds";
                break;
            case 2:
                self.genreValue.text = @"Songs";
                break;
    }
    
   // NSMutableArray *Piano = [NSMutableArray arrayWithObjects: @"AndantePiano1","AndantePiano2","AndantePiano3", nil];
       // audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"smooth kick 1" withExtension:@ "wav"]];
   // for(int i = 1; i < 3; i++) {
        //audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano2" withExtension:@ "wav"] error:&error];
       // NSString *temp = [NSString stringWithFormat:@"%d",i];
        //NSString *song = @"AndantePiano" + temp;
        //audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: Piano[i] withExtension:@ "wav"] error:&error];
        

/*
    for(int i = 0; i < 33; i++) {
        [Piano addObject:@"None"]; // want to be empty here
    }
    for(int i = 33; i < 40; i++) {
        NSString *check = @"AndantePiano";
        check = [check stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource: check withExtension:@ "wav"] error:&error];
        [audioPlayer2 prepareToPlay];
        [Piano addObject:audioPlayer2]; // adds objects to array
      //  audioPlayer2.currentTime = 2 + 40*i;
       // [audioPlayer2 play];
        
        */
    
    
    Piano33 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano33" withExtension:@ "wav"] error:&error];
        [Piano33 prepareToPlay];
    // [Piano addObject: Piano32];
       // addObject:[Piano objectAtIndex:33];
   // [Piano33 play]; // A1
    // [(AVAudioPlayer*)[Piano objectAtIndex: 0] play]; ***ISSSUE MELISSA
        
    Piano34 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano34" withExtension:@ "wav"] error:&error];
    [Piano34 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano34 play];
    
    Piano35 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano35" withExtension:@ "wav"] error:&error];
    [Piano35 prepareToPlay];
   // [Piano addObject: Piano32];
    //[Piano35 play];
    
    Piano36 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano36" withExtension:@ "wav"] error:&error];
    [Piano36 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano36 play];
    
    Piano37 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano37" withExtension:@ "wav"] error:&error];
    [Piano37 prepareToPlay];
   // [Piano addObject: Piano32];
    //[Piano37 play];
    
    Piano38 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano38" withExtension:@ "wav"] error:&error];
    [Piano38 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano38 play];
    
    Piano39 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano39" withExtension:@ "wav"] error:&error];
    [Piano39 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano39 play];
    
    Piano40 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano40" withExtension:@ "wav"] error:&error];
    [Piano40 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano40 play];
    
    Piano41 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano41" withExtension:@ "wav"] error:&error];
    [Piano41 prepareToPlay];
   // [Piano addObject: Piano32];
    //[Piano41 play];
    
    Piano42 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano42" withExtension:@ "wav"] error:&error];
    [Piano42 prepareToPlay];
   // [Piano addObject: Piano32];
    //  [Piano42 play];
    
    Piano43 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano43" withExtension:@ "wav"] error:&error];
    [Piano43 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano43 play];

  //  Piano44 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano44" withExtension:@ "wav"] error:&error];
  //  [Piano44 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano44 play];

  //  Piano45 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano45" withExtension:@ "wav"] error:&error];
  //  [Piano45 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano45 play];

   // Piano46 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano46" withExtension:@ "wav"] error:&error];
   // [Piano46 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano46 play];

   // Piano47 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano47" withExtension:@ "wav"] error:&error];
   // [Piano47 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano47 play];

    Piano48 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano48" withExtension:@ "wav"] error:&error];
    [Piano48 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano48 play];


    Piano49 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano49" withExtension:@ "wav"] error:&error];
    [Piano49 prepareToPlay];
   // [Piano addObject: Piano32];
    // [Piano49 play];

    Piano50 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano50" withExtension:@ "wav"] error:&error];
    [Piano50 prepareToPlay];
    // [Piano50 play];

    Piano51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano51" withExtension:@ "wav"] error:&error];
    [Piano51 prepareToPlay];
    // [Piano51 play];

    Piano52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano52" withExtension:@ "wav"] error:&error];
    [Piano52 prepareToPlay];
    // [Piano52 play];


    Piano53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano53" withExtension:@ "wav"] error:&error];
    [Piano53 prepareToPlay];
    // [Piano53 play];

    Piano54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano54" withExtension:@ "wav"] error:&error];
    [Piano54 prepareToPlay];
    // [Piano54 play];

    Piano55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano55" withExtension:@ "wav"] error:&error];
    [Piano55 prepareToPlay];
   // [Piano55 play];

  //  Piano56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano56" withExtension:@ "wav"] error:&error];
  //  [Piano56 prepareToPlay];
    // [Piano56 play];

    Piano57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano57" withExtension:@ "wav"] error:&error];
    [Piano57 prepareToPlay];
    //[Piano57 play];
    
    Piano58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano58" withExtension:@ "wav"] error:&error];
    [Piano58 prepareToPlay];
    //[Piano58 play];

    Piano59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano59" withExtension:@ "wav"] error:&error];
    [Piano59 prepareToPlay];
    //[Piano59 play];

    Piano60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano60" withExtension:@ "wav"] error:&error];
    [Piano60 prepareToPlay];
    //[Piano60 play];

    Piano51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano51" withExtension:@ "wav"] error:&error];
    [Piano51 prepareToPlay];
    // [Piano51 play];

    Piano52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano52" withExtension:@ "wav"] error:&error];
    [Piano52 prepareToPlay];
    // [Piano52 play];


    Piano53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano53" withExtension:@ "wav"] error:&error];
    [Piano53 prepareToPlay];
    //[Piano53 play];

    Piano54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano54" withExtension:@ "wav"] error:&error];
    [Piano54 prepareToPlay];
    // [Piano54 play];

    Piano55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano55" withExtension:@ "wav"] error:&error];
    [Piano55 prepareToPlay];
    // [Piano55 play];

   // Piano56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano56" withExtension:@ "wav"] error:&error];
  //  [Piano56 prepareToPlay];
    // [Piano56 play];

    Piano57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano57" withExtension:@ "wav"] error:&error];
    [Piano57 prepareToPlay];
    // [Piano57 play];

    Piano58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano58" withExtension:@ "wav"] error:&error];
    [Piano58 prepareToPlay];
    // [Piano58 play];

    Piano59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano59" withExtension:@ "wav"] error:&error];
    [Piano59 prepareToPlay];
    // [Piano59 play];

    Piano60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano60" withExtension:@ "wav"] error:&error];
    [Piano60 prepareToPlay];
    // [Piano60 play];
    
    Piano61 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano61" withExtension:@ "wav"] error:&error];
    [Piano61 prepareToPlay];
    // [Piano61 play];
    
    Piano62 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano62" withExtension:@ "wav"] error:&error];
    [Piano62 prepareToPlay];
    // [Piano62 play];
    
    Piano62 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano62" withExtension:@ "wav"] error:&error];
    [Piano62 prepareToPlay];
    //  [Piano62 play];
    
    Piano63 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano63" withExtension:@ "wav"] error:&error];
    [Piano63 prepareToPlay];
    //  [Piano63 play];
    
    Piano64 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano64" withExtension:@ "wav"] error:&error];
    [Piano64 prepareToPlay];
    // [Piano64 play];
    
    Piano65 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano65" withExtension:@ "wav"] error:&error];
    [Piano65 prepareToPlay];
    //  [Piano65 play];
    
    Piano66 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano66" withExtension:@ "wav"] error:&error];
    [Piano66 prepareToPlay];
    //  [Piano66 play];
    
    Piano67 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano67" withExtension:@ "wav"] error:&error];
    [Piano67 prepareToPlay];
    // [Piano67 play];
    
    Piano68 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano68" withExtension:@ "wav"] error:&error];
    [Piano68 prepareToPlay];
    // [Piano68 play];
    
    Piano69 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano69" withExtension:@ "wav"] error:&error];
    [Piano69 prepareToPlay];
    // [Piano69 play];
    
    
    Piano70 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano70" withExtension:@ "wav"] error:&error];
    [Piano70 prepareToPlay];
    // [Piano70 play];
    
    Piano71 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano71" withExtension:@ "wav"] error:&error];
    [Piano71 prepareToPlay];
    //  [Piano71 play];
    
    Piano72 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano72" withExtension:@ "wav"] error:&error];
    [Piano72 prepareToPlay];
    //  [Piano72 play];
    
    Piano73 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano73" withExtension:@ "wav"] error:&error];
    [Piano73 prepareToPlay];
    //  [Piano73 play];
    
    Piano74 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano74" withExtension:@ "wav"] error:&error];
    [Piano74 prepareToPlay];
    // [Piano74 play];
    
    
    Piano75 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano75" withExtension:@ "wav"] error:&error];
    [Piano75 prepareToPlay];
    //  [Piano75 play];
    
    Piano76 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano76" withExtension:@ "wav"] error:&error];
    [Piano76 prepareToPlay];
    // [Piano76 play];
    
    Piano77 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano77" withExtension:@ "wav"] error:&error];
    [Piano77 prepareToPlay];
    // [Piano77 play];
    
    Piano78 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano78" withExtension:@ "wav"] error:&error];
    [Piano78 prepareToPlay];
    // [Piano78 play];
    
    Piano79 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano79" withExtension:@ "wav"] error:&error];
    [Piano79 prepareToPlay];
    //[Piano79 play];
    
    Piano80 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano80" withExtension:@ "wav"] error:&error];
    [Piano80 prepareToPlay];
    // [Piano80 play];

}


    // THIS CODE WORKS!!
    /*
    audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano33" withExtension:@ "wav"] error:&error];
    [audioPlayer2 prepareToPlay];
    [audioPlayer2 play];
     */

    
    
    
    /*self.genreValue.text = [NSString stringWithFormat:@"%d", Globalgenre];
    */
    
    /*
    // Moved below to button press area rather than here
    // Added below, modeled off of (https://ccrma.stanford.edu/~rmichon/faustTutorials/#adding-faust-real-time-audio-support-to-ios-apps)
     
    const int SR = 44100;
    const int bufferSize = 256;
                      
    dspFaust = new DspFaust(SR,bufferSize);
    dspFaust->start();
    dspFaust->setParamValue("/synth/gate", 1);
    //dspFaust->setParamValue(3, 1);*/
     


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
  //  [Piano33 play]; // A
  //  [Piano37 play]; // C#
   // [Piano40 play]; // E
   // [soundOn addObject:Piano33]; // adds objects to array
   // [soundOn addObject:Piano37]; // adds objects to array
    //[soundOn addObject:Piano40]; // adds objects to array
    
    if (prevGenre != Globalgenre) {
        [self turnOff]; // reset sounds
    }
    if (Globalgenre == 0) { // Minor
      //  [self genreTrap];
        [self playPiano:Piano78];
        
        
      //  [Piano33 stop]; // A
      //  [Piano37 stop]; // C#
      //  [Piano40 stop];
      //  [Piano60 play];
      //  [Piano63 play];
      //  [Piano67 play];
        
        
        
        
       // [soundOn addObject:Piano60]; // adds objects to array
       // [soundOn addObject:Piano63]; // adds objects to array
       // [soundOn addObject:Piano67]; // adds objects to array
       // [self Piano];
        prevGenre = 0;
      //  [kick play];
    }
    else if (Globalgenre == 1) { // RandomSongs
        //[Piano33 play]; // A
       // [Piano37 play]; // C#
       // [Piano40 play]; // E
       // [Piano addObject:Piano33];
        [Piano addObject:Piano37];
        [Piano addObject:Piano40];
        [[Piano objectAtIndex:(33-33)] play];
      //  [self genreRS];
        prevGenre = 1;
        
       // [phone play];
    }
    else if (Globalgenre == 2) { // Songs
       // [self genreSongs];
        prevGenre = 2;
       // [sunshine play];
    }
    else { // pick a genre
      //  [self noAP];
       // [no play];
    }
    
    
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


-(void)playPiano:(AVAudioPlayer*)key, ...{
    [key play];
    /*
    va_list args;
    va_start(args, normal);
    
    id arg = nil;
    while((arg = va_arg(args,id))){
        [args play];
    }
     */
}



- (IBAction)Genre:(id)sender {
    // resets for things that go to other pages because of memory, "pause music" truly only does pause
    [self turnOff];
}


-(void)turnOff {
    for(id tempObject in soundOn) { // loop through every element in the array
        [tempObject stop]; // change to stop later...
        [soundOn removeObject:tempObject]; // remove object once it has been turned off
  //      NSLog(@"Single element: %@", tempObject);
    }
}

-(void)Piano {
   // [soundOn removeAllObjects];
    [self APPiano48];
    [self APPiano53];
    [self APPiano55];
    [Piano48 play];
    [Piano53 play];
    [Piano55 play];
  //  for(int i = 33; i < [Piano count]; i++) {
        //[(AVAudioPlayer*)[Piano objectAtIndex:i] play];
        
      //  if (![soundOn containsObject:[Trap objectAtIndex:i]]) {
      //  [soundOn addObject:[Trap objectAtIndex:i]]; // adds objects to array
      //  }
}



-(void)genreTrap {
   // [soundOn removeAllObjects];
  //  [self kickAP];
    [Piano33 play];
    /*
    NSMutableArray* Trap = [NSMutableArray arrayWithObjects: kick, hat, nil];
    for(int i = 0; i < [Trap count]; i++) {
        [(AVAudioPlayer*)[Trap objectAtIndex:i] play];
        
        if (![soundOn containsObject:[Trap objectAtIndex:i]]) {
        [soundOn addObject:[Trap objectAtIndex:i]]; // adds objects to array
        }
    }
     */
}

-(void)genreRS {
 //   NSInteger limit = [randomSoundsArrayAP count];
   // NSMutableArray* RS = [NSMutableArray arrayWithObjects: car, phone, nil];
 //   for(int i = 0; i < [RS count]; i++) {
        //[(AVAudioPlayer*)[RS objectAtIndex:i] play];
      /*
        if (![soundOn containsObject:[RS objectAtIndex:i]]) {
        [soundOn addObject:[RS objectAtIndex:i]]; // adds objects to array
        }
   // }
    [self turnOff];
    [(AVAudioPlayer*)[RS objectAtIndex:1] play];
       */
    [Piano37 play];
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

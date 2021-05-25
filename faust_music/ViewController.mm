//
//  ViewController.m
//  faust_music
//
//
#import "ViewController.h"
#import "DspFaust.h"
#import <AVFoundation/AVFoundation.h>
//#import "ViewController2.h"
//#import "ViewController3.h"
#import <stdarg.h>

#define HEEL_STRIKE         0       // tonic (do)
#define TOE_OFF             9       // submediant (la)
#define NUM_FIFTHS          12
#define KNEE_DIFF_THRESH    30
#define PLAY_SNARE          100
#define PLAY_KICK           101
#define PLAY_HAT            102
#define CALIBRATION         103

NSLock *theLock  = [[NSLock alloc] init];

NSDictionary *Piano;
NSDictionary *EP; // Electric Piano
NSDictionary *BassAndEP; // Bass and Electric Piano
NSDictionary *Acoustic; // Acoustic Drum Kit
NSDictionary *Trap; // Trap Drum Kit

NSString *instrument = @"Piano";
NSString *drumKit = @"Acoustic";

BOOL modeToe;
BOOL genreBass;
                         
@interface ViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSString *footDeviceName;
@property (nonatomic, strong) NSString *kneeDeviceName;

@property (nonatomic, strong) NSString *bleDevice;
@property (nonatomic, strong) NSMutableArray *pickerData;
@property (nonatomic, strong) NSMutableArray *devices;
@property CBCentralManager *myManager;

@property (weak, nonatomic) IBOutlet UILabel *currInstrumentTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property(nonatomic,strong)NSTimer *timer; // for Ding
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)IBOutlet UIButton *Genre; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *MusicSelection; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *DividingLine; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIImageView *SpeakerOnImg; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIImageView *SpeakerOffImg; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UITextView *detuneInstructions; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *DrumKit; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIImageView *Logo; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIImageView *Walking; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *Detune; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *PlayChord;

@property(nonatomic,strong)IBOutlet UIButton *StopChord;

@property(nonatomic,strong)IBOutlet UIButton *Connect; // to allow for scrolling

@property(nonatomic,strong)IBOutlet UIButton *GaitMode; // to allow for scrolling

@property (strong, nonatomic) IBOutlet UISwitch *modeSwitch;

@property (strong, nonatomic) IBOutlet UILabel *modeLabel;

// For Detune
@property (strong, nonatomic) IBOutlet UITextField *tfValue;
@property (strong, nonatomic) IBOutlet UISlider *slider;

// For Genre
@property (weak, nonatomic) IBOutlet UIPickerView *genrePicker;
@property (nonatomic, strong) NSMutableArray *genrePickerData;

// For Drum Kit
@property (weak, nonatomic) IBOutlet UIPickerView *drumPicker;
@property (nonatomic, strong) NSMutableArray *drumPickerData;

// Acoustic Drumset
@property(nonatomic,strong)AVAudioPlayer *APAcousticKick;
@property(nonatomic,strong)AVAudioPlayer *APAcousticHat;
@property(nonatomic,strong)AVAudioPlayer *APAcousticSnare;


// Trap Kit
@property(nonatomic,strong)AVAudioPlayer *APTrapKick;
@property(nonatomic,strong)AVAudioPlayer *APTrapHat;
@property(nonatomic,strong)AVAudioPlayer *APTrapSnare;


// Piano
@property(nonatomic,strong)AVAudioPlayer *APPiano24;
@property(nonatomic,strong)AVAudioPlayer *APPiano25;
@property(nonatomic,strong)AVAudioPlayer *APPiano26;
@property(nonatomic,strong)AVAudioPlayer *APPiano27;
@property(nonatomic,strong)AVAudioPlayer *APPiano28;
@property(nonatomic,strong)AVAudioPlayer *APPiano29;
@property(nonatomic,strong)AVAudioPlayer *APPiano30;
@property(nonatomic,strong)AVAudioPlayer *APPiano31;
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
@property(nonatomic,strong)AVAudioPlayer *APPiano44;
@property(nonatomic,strong)AVAudioPlayer *APPiano45;
@property(nonatomic,strong)AVAudioPlayer *APPiano46;
@property(nonatomic,strong)AVAudioPlayer *APPiano47;
@property(nonatomic,strong)AVAudioPlayer *APPiano48;
@property(nonatomic,strong)AVAudioPlayer *APPiano49;
@property(nonatomic,strong)AVAudioPlayer *APPiano50;
@property(nonatomic,strong)AVAudioPlayer *APPiano51;
@property(nonatomic,strong)AVAudioPlayer *APPiano52;
@property(nonatomic,strong)AVAudioPlayer *APPiano53;
@property(nonatomic,strong)AVAudioPlayer *APPiano54;
@property(nonatomic,strong)AVAudioPlayer *APPiano55;
@property(nonatomic,strong)AVAudioPlayer *APPiano56;
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
@property(nonatomic,strong)AVAudioPlayer *APPiano81;
@property(nonatomic,strong)AVAudioPlayer *APPiano82;
@property(nonatomic,strong)AVAudioPlayer *APPiano83;
@property(nonatomic,strong)AVAudioPlayer *APPiano84;
@property(nonatomic,strong)AVAudioPlayer *APPiano85;
@property(nonatomic,strong)AVAudioPlayer *APPiano86;
@property(nonatomic,strong)AVAudioPlayer *APPiano87;
@property(nonatomic,strong)AVAudioPlayer *APPiano88;
@property(nonatomic,strong)AVAudioPlayer *APPiano89;
@property(nonatomic,strong)AVAudioPlayer *APPiano90;
@property(nonatomic,strong)AVAudioPlayer *APPiano91;
@property(nonatomic,strong)AVAudioPlayer *APPiano92;
@property(nonatomic,strong)AVAudioPlayer *APPiano93;
@property(nonatomic,strong)AVAudioPlayer *APPiano94;
@property(nonatomic,strong)AVAudioPlayer *APPiano95;
@property(nonatomic,strong)AVAudioPlayer *APPiano96;

// Electric Piano
@property(nonatomic,strong)AVAudioPlayer *APEP24;
@property(nonatomic,strong)AVAudioPlayer *APEP25;
@property(nonatomic,strong)AVAudioPlayer *APEP26;
@property(nonatomic,strong)AVAudioPlayer *APEP27;
@property(nonatomic,strong)AVAudioPlayer *APEP28;
@property(nonatomic,strong)AVAudioPlayer *APEP29;
@property(nonatomic,strong)AVAudioPlayer *APEP30;
@property(nonatomic,strong)AVAudioPlayer *APEP31;
@property(nonatomic,strong)AVAudioPlayer *APEP32;
@property(nonatomic,strong)AVAudioPlayer *APEP33;
@property(nonatomic,strong)AVAudioPlayer *APEP34;
@property(nonatomic,strong)AVAudioPlayer *APEP35;
@property(nonatomic,strong)AVAudioPlayer *APEP36;
@property(nonatomic,strong)AVAudioPlayer *APEP37;
@property(nonatomic,strong)AVAudioPlayer *APEP38;
@property(nonatomic,strong)AVAudioPlayer *APEP39;
@property(nonatomic,strong)AVAudioPlayer *APEP40;
@property(nonatomic,strong)AVAudioPlayer *APEP41;
@property(nonatomic,strong)AVAudioPlayer *APEP42;
@property(nonatomic,strong)AVAudioPlayer *APEP43;
@property(nonatomic,strong)AVAudioPlayer *APEP44;
@property(nonatomic,strong)AVAudioPlayer *APEP45;
@property(nonatomic,strong)AVAudioPlayer *APEP46;
@property(nonatomic,strong)AVAudioPlayer *APEP47;
@property(nonatomic,strong)AVAudioPlayer *APEP48;
@property(nonatomic,strong)AVAudioPlayer *APEP49;
@property(nonatomic,strong)AVAudioPlayer *APEP50;
@property(nonatomic,strong)AVAudioPlayer *APEP51;
@property(nonatomic,strong)AVAudioPlayer *APEP52;
@property(nonatomic,strong)AVAudioPlayer *APEP53;
@property(nonatomic,strong)AVAudioPlayer *APEP54;
@property(nonatomic,strong)AVAudioPlayer *APEP55;
@property(nonatomic,strong)AVAudioPlayer *APEP56;
@property(nonatomic,strong)AVAudioPlayer *APEP57;
@property(nonatomic,strong)AVAudioPlayer *APEP58;
@property(nonatomic,strong)AVAudioPlayer *APEP59;
@property(nonatomic,strong)AVAudioPlayer *APEP60;
@property(nonatomic,strong)AVAudioPlayer *APEP61;
@property(nonatomic,strong)AVAudioPlayer *APEP62;
@property(nonatomic,strong)AVAudioPlayer *APEP63;
@property(nonatomic,strong)AVAudioPlayer *APEP64;
@property(nonatomic,strong)AVAudioPlayer *APEP65;
@property(nonatomic,strong)AVAudioPlayer *APEP66;
@property(nonatomic,strong)AVAudioPlayer *APEP67;
@property(nonatomic,strong)AVAudioPlayer *APEP68;
@property(nonatomic,strong)AVAudioPlayer *APEP69;
@property(nonatomic,strong)AVAudioPlayer *APEP70;
@property(nonatomic,strong)AVAudioPlayer *APEP71;
@property(nonatomic,strong)AVAudioPlayer *APEP72;
@property(nonatomic,strong)AVAudioPlayer *APEP73;
@property(nonatomic,strong)AVAudioPlayer *APEP74;
@property(nonatomic,strong)AVAudioPlayer *APEP75;
@property(nonatomic,strong)AVAudioPlayer *APEP76;
@property(nonatomic,strong)AVAudioPlayer *APEP77;
@property(nonatomic,strong)AVAudioPlayer *APEP78;
@property(nonatomic,strong)AVAudioPlayer *APEP79;
@property(nonatomic,strong)AVAudioPlayer *APEP80;
@property(nonatomic,strong)AVAudioPlayer *APEP81;
@property(nonatomic,strong)AVAudioPlayer *APEP82;
@property(nonatomic,strong)AVAudioPlayer *APEP83;
@property(nonatomic,strong)AVAudioPlayer *APEP84;
@property(nonatomic,strong)AVAudioPlayer *APEP85;
@property(nonatomic,strong)AVAudioPlayer *APEP86;
@property(nonatomic,strong)AVAudioPlayer *APEP87;
@property(nonatomic,strong)AVAudioPlayer *APEP88;
@property(nonatomic,strong)AVAudioPlayer *APEP89;
@property(nonatomic,strong)AVAudioPlayer *APEP90;
@property(nonatomic,strong)AVAudioPlayer *APEP91;
@property(nonatomic,strong)AVAudioPlayer *APEP92;
@property(nonatomic,strong)AVAudioPlayer *APEP93;
@property(nonatomic,strong)AVAudioPlayer *APEP94;
@property(nonatomic,strong)AVAudioPlayer *APEP95;
@property(nonatomic,strong)AVAudioPlayer *APEP96;

// Bass and Electric Piano
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP24;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP25;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP26;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP27;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP28;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP29;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP30;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP31;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP32;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP33;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP34;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP35;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP36;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP37;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP38;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP39;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP40;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP41;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP42;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP43;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP44;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP45;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP46;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP47;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP48;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP49;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP50;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP51;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP52;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP53;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP54;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP55;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP56;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP57;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP58;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP59;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP60;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP61;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP62;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP63;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP64;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP65;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP66;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP67;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP68;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP69;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP70;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP71;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP72;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP73;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP74;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP75;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP76;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP77;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP78;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP79;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP80;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP81;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP82;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP83;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP84;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP85;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP86;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP87;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP88;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP89;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP90;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP91;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP92;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP93;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP94;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP95;
@property(nonatomic,strong)AVAudioPlayer *APBassAndEP96;

// Sound Effects
@property(nonatomic,strong)AVAudioPlayer *APDing;

// More Instruments here

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


// Insert more genres

// ACOUSTIC DRUMSET
@synthesize APAcousticKick = AcousticKick;
@synthesize APAcousticSnare = AcousticSnare;
@synthesize APAcousticHat = AcousticHat;

// TRAP KIT
@synthesize APTrapKick = TrapKick;
@synthesize APTrapSnare = TrapSnare;
@synthesize APTrapHat = TrapHat;

// PIANO
@synthesize APPiano24 = Piano24;
@synthesize APPiano25 = Piano25;
@synthesize APPiano26 = Piano26;
@synthesize APPiano27 = Piano27;
@synthesize APPiano28 = Piano28;
@synthesize APPiano29 = Piano29;
@synthesize APPiano30 = Piano30;
@synthesize APPiano31 = Piano31;
@synthesize APPiano32 = Piano32;
@synthesize APPiano33 = Piano33;
@synthesize APPiano34 = Piano34;
@synthesize APPiano35 = Piano35;
@synthesize APPiano36 = Piano36;
@synthesize APPiano37 = Piano37;
@synthesize APPiano38 = Piano38;
@synthesize APPiano39 = Piano39;
@synthesize APPiano40 = Piano40;
@synthesize APPiano41 = Piano41;
@synthesize APPiano42 = Piano42;
@synthesize APPiano43 = Piano43;
@synthesize APPiano44 = Piano44;
@synthesize APPiano45 = Piano45;
@synthesize APPiano46 = Piano46;
@synthesize APPiano47 = Piano47;
@synthesize APPiano48 = Piano48;
@synthesize APPiano49 = Piano49;
@synthesize APPiano50 = Piano50;
@synthesize APPiano51 = Piano51;
@synthesize APPiano52 = Piano52;
@synthesize APPiano53 = Piano53;
@synthesize APPiano54 = Piano54;
@synthesize APPiano55 = Piano55;
@synthesize APPiano56 = Piano56;
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
@synthesize APPiano81 = Piano81;
@synthesize APPiano82 = Piano82;
@synthesize APPiano83 = Piano83;
@synthesize APPiano84 = Piano84;
@synthesize APPiano85 = Piano85;
@synthesize APPiano86 = Piano86;
@synthesize APPiano87 = Piano87;
@synthesize APPiano88 = Piano88;
@synthesize APPiano89 = Piano89;
@synthesize APPiano90 = Piano90;
@synthesize APPiano91 = Piano91;
@synthesize APPiano92 = Piano92;
@synthesize APPiano93 = Piano93;
@synthesize APPiano94 = Piano94;
@synthesize APPiano95 = Piano95;
@synthesize APPiano96 = Piano96;

// Electric Piano
@synthesize APEP24 = EP24;
@synthesize APEP25 = EP25;
@synthesize APEP26 = EP26;
@synthesize APEP27 = EP27;
@synthesize APEP28 = EP28;
@synthesize APEP29 = EP29;
@synthesize APEP30 = EP30;
@synthesize APEP31 = EP31;
@synthesize APEP32 = EP32;
@synthesize APEP33 = EP33;
@synthesize APEP34 = EP34;
@synthesize APEP35 = EP35;
@synthesize APEP36 = EP36;
@synthesize APEP37 = EP37;
@synthesize APEP38 = EP38;
@synthesize APEP39 = EP39;
@synthesize APEP40 = EP40;
@synthesize APEP41 = EP41;
@synthesize APEP42 = EP42;
@synthesize APEP43 = EP43;
@synthesize APEP44 = EP44;
@synthesize APEP45 = EP45;
@synthesize APEP46 = EP46;
@synthesize APEP47 = EP47;
@synthesize APEP48 = EP48;
@synthesize APEP49 = EP49;
@synthesize APEP50 = EP50;
@synthesize APEP51 = EP51;
@synthesize APEP52 = EP52;
@synthesize APEP53 = EP53;
@synthesize APEP54 = EP54;
@synthesize APEP55 = EP55;
@synthesize APEP56 = EP56;
@synthesize APEP57 = EP57;
@synthesize APEP58 = EP58;
@synthesize APEP59 = EP59;
@synthesize APEP60 = EP60;
@synthesize APEP61 = EP61;
@synthesize APEP62 = EP62;
@synthesize APEP63 = EP63;
@synthesize APEP64 = EP64;
@synthesize APEP65 = EP65;
@synthesize APEP66 = EP66;
@synthesize APEP67 = EP67;
@synthesize APEP68 = EP68;
@synthesize APEP69 = EP69;
@synthesize APEP70 = EP70;
@synthesize APEP71 = EP71;
@synthesize APEP72 = EP72;
@synthesize APEP73 = EP73;
@synthesize APEP74 = EP74;
@synthesize APEP75 = EP75;
@synthesize APEP76 = EP76;
@synthesize APEP77 = EP77;
@synthesize APEP78 = EP78;
@synthesize APEP79 = EP79;
@synthesize APEP80 = EP80;
@synthesize APEP81 = EP81;
@synthesize APEP82 = EP82;
@synthesize APEP83 = EP83;
@synthesize APEP84 = EP84;
@synthesize APEP85 = EP85;
@synthesize APEP86 = EP86;
@synthesize APEP87 = EP87;
@synthesize APEP88 = EP88;
@synthesize APEP89 = EP89;
@synthesize APEP90 = EP90;
@synthesize APEP91 = EP91;
@synthesize APEP92 = EP92;
@synthesize APEP93 = EP93;
@synthesize APEP94 = EP94;
@synthesize APEP95 = EP95;
@synthesize APEP96 = EP96;

// Bass and Electric Piano
@synthesize APBassAndEP24 = BassAndEP24;
@synthesize APBassAndEP25 = BassAndEP25;
@synthesize APBassAndEP26 = BassAndEP26;
@synthesize APBassAndEP27 = BassAndEP27;
@synthesize APBassAndEP28 = BassAndEP28;
@synthesize APBassAndEP29 = BassAndEP29;
@synthesize APBassAndEP30 = BassAndEP30;
@synthesize APBassAndEP31 = BassAndEP31;
@synthesize APBassAndEP32 = BassAndEP32;
@synthesize APBassAndEP33 = BassAndEP33;
@synthesize APBassAndEP34 = BassAndEP34;
@synthesize APBassAndEP35 = BassAndEP35;
@synthesize APBassAndEP36 = BassAndEP36;
@synthesize APBassAndEP37 = BassAndEP37;
@synthesize APBassAndEP38 = BassAndEP38;
@synthesize APBassAndEP39 = BassAndEP39;
@synthesize APBassAndEP40 = BassAndEP40;
@synthesize APBassAndEP41 = BassAndEP41;
@synthesize APBassAndEP42 = BassAndEP42;
@synthesize APBassAndEP43 = BassAndEP43;
@synthesize APBassAndEP44 = BassAndEP44;
@synthesize APBassAndEP45 = BassAndEP45;
@synthesize APBassAndEP46 = BassAndEP46;
@synthesize APBassAndEP47 = BassAndEP47;
@synthesize APBassAndEP48 = BassAndEP48;
@synthesize APBassAndEP49 = BassAndEP49;
@synthesize APBassAndEP50 = BassAndEP50;
@synthesize APBassAndEP51 = BassAndEP51;
@synthesize APBassAndEP52 = BassAndEP52;
@synthesize APBassAndEP53 = BassAndEP53;
@synthesize APBassAndEP54 = BassAndEP54;
@synthesize APBassAndEP55 = BassAndEP55;
@synthesize APBassAndEP56 = BassAndEP56;
@synthesize APBassAndEP57 = BassAndEP57;
@synthesize APBassAndEP58 = BassAndEP58;
@synthesize APBassAndEP59 = BassAndEP59;
@synthesize APBassAndEP60 = BassAndEP60;
@synthesize APBassAndEP61 = BassAndEP61;
@synthesize APBassAndEP62 = BassAndEP62;
@synthesize APBassAndEP63 = BassAndEP63;
@synthesize APBassAndEP64 = BassAndEP64;
@synthesize APBassAndEP65 = BassAndEP65;
@synthesize APBassAndEP66 = BassAndEP66;
@synthesize APBassAndEP67 = BassAndEP67;
@synthesize APBassAndEP68 = BassAndEP68;
@synthesize APBassAndEP69 = BassAndEP69;
@synthesize APBassAndEP70 = BassAndEP70;
@synthesize APBassAndEP71 = BassAndEP71;
@synthesize APBassAndEP72 = BassAndEP72;
@synthesize APBassAndEP73 = BassAndEP73;
@synthesize APBassAndEP74 = BassAndEP74;
@synthesize APBassAndEP75 = BassAndEP75;
@synthesize APBassAndEP76 = BassAndEP76;
@synthesize APBassAndEP77 = BassAndEP77;
@synthesize APBassAndEP78 = BassAndEP78;
@synthesize APBassAndEP79 = BassAndEP79;
@synthesize APBassAndEP80 = BassAndEP80;
@synthesize APBassAndEP81 = BassAndEP81;
@synthesize APBassAndEP82 = BassAndEP82;
@synthesize APBassAndEP83 = BassAndEP83;
@synthesize APBassAndEP84 = BassAndEP84;
@synthesize APBassAndEP85 = BassAndEP85;
@synthesize APBassAndEP86 = BassAndEP86;
@synthesize APBassAndEP87 = BassAndEP87;
@synthesize APBassAndEP88 = BassAndEP88;
@synthesize APBassAndEP89 = BassAndEP89;
@synthesize APBassAndEP90 = BassAndEP90;
@synthesize APBassAndEP91 = BassAndEP91;
@synthesize APBassAndEP92 = BassAndEP92;
@synthesize APBassAndEP93 = BassAndEP93;
@synthesize APBassAndEP94 = BassAndEP94;
@synthesize APBassAndEP95 = BassAndEP95;
@synthesize APBassAndEP96 = BassAndEP96;

@synthesize APDing = Ding;

int chordCounter = 0;
int chordMIDIs[4][6] = {{48,55,60,64,60,55}, {43,50,55,59,55,50}, {45,52,57,60,57,52}, {41,48,53,57,53,48}}; // C G Am F
int notesPerChord = 6;    // update manually to match above
int currentArpNote = 0;
int kneeRanges[5] = {60,50,30,50,60};  // calibrate
int lastKneeVal = 0;
int prevArpNote = 0;   // weird workaround for starting at zero and not wanting to get a neg index error
float currentDetune = 0.0f;
float detuneAmount = 0.0f;


int Globalgenre = -1; // probably move later

int globalMaxDetune = 0; // here?

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    const int SR = 44100;
    const int bufferSize = 256;

       
     dspFaust = new DspFaust(SR,bufferSize);
     dspFaust->start();
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5)];
    
    // Add items for them to be included in scroll

    [_scrollView addSubview:_Logo];
    [_scrollView addSubview:_picker];
    [_scrollView addSubview:_Connect];

    [_scrollView addSubview:_modeSwitch];
    [_scrollView addSubview:_modeLabel];
    [_scrollView addSubview: _Genre];
    [_scrollView addSubview:_DrumKit];
    [_scrollView addSubview:_genrePicker];
    [_scrollView addSubview: _drumPicker];
    [_scrollView addSubview: _slider];
    [_scrollView addSubview:_tfValue];
    [_scrollView addSubview:_PlayChord];
    [_scrollView addSubview:_StopChord];
    [_scrollView addSubview:_Detune];
    [_scrollView addSubview:_MusicSelection];
    [_scrollView addSubview:_DividingLine];
    [_scrollView addSubview:_Walking];
    [_scrollView addSubview:_SpeakerOnImg];
    [_scrollView addSubview:_SpeakerOffImg];
    [_scrollView addSubview:_detuneInstructions];
    [_scrollView addSubview:_GaitMode];
 
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
    
    _genrePickerData = [[NSMutableArray alloc]init];
    [_genrePickerData addObject:@"Piano"];
    [_genrePickerData addObject:@"Bass"];
    [_genrePickerData addObject:@"Electric Piano"];
    _genrePicker.dataSource = self;
    _genrePicker.delegate = self;
    
    _drumPickerData = [[NSMutableArray alloc]init];
    [_drumPickerData addObject:@"Acoustic"];
    [_drumPickerData addObject:@"Trap"];
    _drumPicker.dataSource = self;
    _drumPicker.delegate = self;
    
    _picker.tag = 1;
    _genrePicker.tag = 2;
    _drumPicker.tag = 3;
    
    
    state = TOE_OFF;
       int co5[NUM_FIFTHS] = {48,55,50,57,52,59,54,49,56,51,58,53};
       memcpy(circleOf5ths, co5, sizeof(co5));
       tonicIdx = 0;
       kneeStanceAvg = 0;
       numStanceAvg = 0;
       tonicChange = false;
       
       _footDeviceName = @"Bluefruit52 MIDI foot";
       _kneeDeviceName = @"Bluefruit52 MIDI knee";
    
    
    NSError *error;
    if(modeToe == true) {
        _modeLabel.text = @"Swing Phase";
    }
    else{
        _modeLabel.text = @"Stance Phase";
    }
    
    _slider.value = globalMaxDetune/0.20; // change constants later (the 0.2)
    self.tfValue.text = [NSString stringWithFormat:@"%f", _slider.value];
    
    // For Sound Fonts
    // Acoustic Drums
    AcousticKick = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsAcousticKick" withExtension:@ "wav"] error:&error];
    [AcousticKick prepareToPlay];

    AcousticSnare = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsAcousticSnare" withExtension:@ "wav"] error:&error];
    [AcousticSnare prepareToPlay];
    
    AcousticHat = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsAcousticHat" withExtension:@ "wav"] error:&error];
    [AcousticHat prepareToPlay];
    
    
    // Acoustic Drum Kit dictionary initialization
    NSArray *valuesAcoustic = [NSArray arrayWithObjects: AcousticKick, AcousticSnare, AcousticHat, nil];
    
    NSArray *keysAcoustic = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],nil];

    Acoustic = [NSDictionary dictionaryWithObjects: valuesAcoustic forKeys: keysAcoustic];
    

    
    // Trap Drums
    TrapKick = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsTrapKick" withExtension:@ "wav"] error:&error];
    [TrapKick prepareToPlay];

    TrapSnare = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsTrapSnare" withExtension:@ "wav"] error:&error];
    [TrapSnare prepareToPlay];
    
    TrapHat = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteDrumsTrapHat" withExtension:@ "wav"] error:&error];
    [TrapHat prepareToPlay];
    
    
    // Trap Drum Kit dictionary initialization
    NSArray *valuesTrap = [NSArray arrayWithObjects: TrapKick, TrapSnare, TrapHat, nil];
    
    NSArray *keysTrap = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],nil];

    Trap = [NSDictionary dictionaryWithObjects: valuesTrap forKeys: keysTrap];
    
        
    Piano24 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano24" withExtension:@ "wav"] error:&error];
    [Piano24 prepareToPlay];

    Piano25 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano25" withExtension:@ "wav"] error:&error];
    [Piano25 prepareToPlay];
    
    Piano26 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano26" withExtension:@ "wav"] error:&error];
    [Piano26 prepareToPlay];
    
    Piano27 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano27" withExtension:@ "wav"] error:&error];
    [Piano27 prepareToPlay];
    
    Piano28 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano28" withExtension:@ "wav"] error:&error];
    [Piano28 prepareToPlay];
    
    Piano29 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano29" withExtension:@ "wav"] error:&error];
    [Piano29 prepareToPlay];
    
    Piano30 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano30" withExtension:@ "wav"] error:&error];
    [Piano30 prepareToPlay];
    
    Piano31 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano31" withExtension:@ "wav"] error:&error];
    [Piano31 prepareToPlay];
    
    Piano32 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano32" withExtension:@ "wav"] error:&error];
    [Piano32 prepareToPlay];
    
    Piano33 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano33" withExtension:@ "wav"] error:&error];
    [Piano33 prepareToPlay];
        
    Piano34 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano34" withExtension:@ "wav"] error:&error];
    [Piano34 prepareToPlay];

    Piano35 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano35" withExtension:@ "wav"] error:&error];
    [Piano35 prepareToPlay];
    
    Piano36 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano36" withExtension:@ "wav"] error:&error];
    [Piano36 prepareToPlay];
    
    Piano37 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano37" withExtension:@ "wav"] error:&error];
    [Piano37 prepareToPlay];
    
    Piano38 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano38" withExtension:@ "wav"] error:&error];
    [Piano38 prepareToPlay];
    
    Piano39 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano39" withExtension:@ "wav"] error:&error];
    [Piano39 prepareToPlay];
    
    Piano40 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano40" withExtension:@ "wav"] error:&error];
    [Piano40 prepareToPlay];
    
    Piano41 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano41" withExtension:@ "wav"] error:&error];
    [Piano41 prepareToPlay];
    
    Piano42 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano42" withExtension:@ "wav"] error:&error];
    [Piano42 prepareToPlay];
    
    Piano43 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano43" withExtension:@ "wav"] error:&error];
    [Piano43 prepareToPlay];

    Piano44 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano44" withExtension:@ "wav"] error:&error];
    [Piano44 prepareToPlay];

    Piano45 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano45" withExtension:@ "wav"] error:&error];
    [Piano45 prepareToPlay];

    Piano46 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano46" withExtension:@ "wav"] error:&error];
    [Piano46 prepareToPlay];

    Piano47 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano47" withExtension:@ "wav"] error:&error];
    [Piano47 prepareToPlay];

    Piano48 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano48" withExtension:@ "wav"] error:&error];
    [Piano48 prepareToPlay];


    Piano49 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano49" withExtension:@ "wav"] error:&error];
    [Piano49 prepareToPlay];

    Piano50 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano50" withExtension:@ "wav"] error:&error];
    [Piano50 prepareToPlay];

    Piano51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano51" withExtension:@ "wav"] error:&error];
    [Piano51 prepareToPlay];

    Piano52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano52" withExtension:@ "wav"] error:&error];
    [Piano52 prepareToPlay];

    Piano53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano53" withExtension:@ "wav"] error:&error];
    [Piano53 prepareToPlay];

    Piano54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano54" withExtension:@ "wav"] error:&error];
    [Piano54 prepareToPlay];

    Piano55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano55" withExtension:@ "wav"] error:&error];
    [Piano55 prepareToPlay];

    Piano56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano56" withExtension:@ "wav"] error:&error];
    [Piano56 prepareToPlay];

    Piano57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano57" withExtension:@ "wav"] error:&error];
    [Piano57 prepareToPlay];
    
    Piano58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano58" withExtension:@ "wav"] error:&error];
    [Piano58 prepareToPlay];

    Piano59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano59" withExtension:@ "wav"] error:&error];
    [Piano59 prepareToPlay];

    Piano60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano60" withExtension:@ "wav"] error:&error];
    [Piano60 prepareToPlay];

    Piano51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano51" withExtension:@ "wav"] error:&error];
    [Piano51 prepareToPlay];

    Piano52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano52" withExtension:@ "wav"] error:&error];
    [Piano52 prepareToPlay];

    Piano53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano53" withExtension:@ "wav"] error:&error];
    [Piano53 prepareToPlay];

    Piano54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano54" withExtension:@ "wav"] error:&error];
    [Piano54 prepareToPlay];

    Piano55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano55" withExtension:@ "wav"] error:&error];
    [Piano55 prepareToPlay];


   Piano56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano56" withExtension:@ "wav"] error:&error];
    [Piano56 prepareToPlay];

    Piano57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano57" withExtension:@ "wav"] error:&error];
    [Piano57 prepareToPlay];

    Piano58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano58" withExtension:@ "wav"] error:&error];
    [Piano58 prepareToPlay];

    Piano59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano59" withExtension:@ "wav"] error:&error];
    [Piano59 prepareToPlay];

    Piano60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano60" withExtension:@ "wav"] error:&error];
    [Piano60 prepareToPlay];
    
    Piano61 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano61" withExtension:@ "wav"] error:&error];
    [Piano61 prepareToPlay];
    
    Piano62 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano62" withExtension:@ "wav"] error:&error];
    [Piano62 prepareToPlay];
    
    Piano63 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano63" withExtension:@ "wav"] error:&error];
    [Piano63 prepareToPlay];
    
    Piano64 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano64" withExtension:@ "wav"] error:&error];
    [Piano64 prepareToPlay];
    
    Piano65 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano65" withExtension:@ "wav"] error:&error];
    [Piano65 prepareToPlay];
    
    Piano66 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano66" withExtension:@ "wav"] error:&error];
    [Piano66 prepareToPlay];
    
    Piano67 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano67" withExtension:@ "wav"] error:&error];
    [Piano67 prepareToPlay];
    
    Piano68 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano68" withExtension:@ "wav"] error:&error];
    [Piano68 prepareToPlay];
    
    Piano69 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano69" withExtension:@ "wav"] error:&error];
    [Piano69 prepareToPlay];

    Piano70 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano70" withExtension:@ "wav"] error:&error];
    [Piano70 prepareToPlay];
    
    Piano71 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano71" withExtension:@ "wav"] error:&error];
    [Piano71 prepareToPlay];
    
    Piano72 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano72" withExtension:@ "wav"] error:&error];
    [Piano72 prepareToPlay];
    
    Piano73 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano73" withExtension:@ "wav"] error:&error];
    [Piano73 prepareToPlay];
    
    Piano74 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano74" withExtension:@ "wav"] error:&error];
    [Piano74 prepareToPlay];
    
    Piano75 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano75" withExtension:@ "wav"] error:&error];
    [Piano75 prepareToPlay];
    
    Piano76 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano76" withExtension:@ "wav"] error:&error];
    [Piano76 prepareToPlay];
    
    Piano77 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano77" withExtension:@ "wav"] error:&error];
    [Piano77 prepareToPlay];
    
    Piano78 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano78" withExtension:@ "wav"] error:&error];
    [Piano78 prepareToPlay];
    
    Piano79 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano79" withExtension:@ "wav"] error:&error];
    [Piano79 prepareToPlay];

    Piano80 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano80" withExtension:@ "wav"] error:&error];
    [Piano80 prepareToPlay];

    
    Piano81 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano81" withExtension:@ "wav"] error:&error];
    [Piano81 prepareToPlay];
    
    Piano82 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano82" withExtension:@ "wav"] error:&error];
    [Piano82 prepareToPlay];
    
    Piano83 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano83" withExtension:@ "wav"] error:&error];
    [Piano83 prepareToPlay];
    
    Piano84 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano84" withExtension:@ "wav"] error:&error];
    [Piano84 prepareToPlay];
    
    Piano85 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano85" withExtension:@ "wav"] error:&error];
    [Piano85 prepareToPlay];
    
    Piano86 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano86" withExtension:@ "wav"] error:&error];
    [Piano86 prepareToPlay];
    
    Piano87 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano87" withExtension:@ "wav"] error:&error];
    [Piano87 prepareToPlay];
    
    Piano88 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano88" withExtension:@ "wav"] error:&error];
    [Piano88 prepareToPlay];
    
    Piano89 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano89" withExtension:@ "wav"] error:&error];
    [Piano89 prepareToPlay];

    Piano90 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano90" withExtension:@ "wav"] error:&error];
    [Piano90 prepareToPlay];
    
    Piano91 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano91" withExtension:@ "wav"] error:&error];
    [Piano91 prepareToPlay];
    
    Piano92 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano92" withExtension:@ "wav"] error:&error];
    [Piano92 prepareToPlay];
    
    Piano93 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano93" withExtension:@ "wav"] error:&error];
    [Piano93 prepareToPlay];
    
    Piano94 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano94" withExtension:@ "wav"] error:&error];
    [Piano94 prepareToPlay];
    
    Piano95 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano95" withExtension:@ "wav"] error:&error];
    [Piano95 prepareToPlay];
    
    Piano96 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndantePiano96" withExtension:@ "wav"] error:&error];
    [Piano96 prepareToPlay];
    
    
    // PIANO dictionary initialization
    NSArray *valuesPiano = [NSArray arrayWithObjects: Piano24, Piano25, Piano26, Piano27, Piano28, Piano29, Piano30, Piano31, Piano32, Piano33, Piano34, Piano35, Piano36, Piano37, Piano38, Piano39, Piano40, Piano41, Piano42, Piano43, Piano44, Piano45, Piano46, Piano47, Piano48, Piano49, Piano50, Piano51, Piano52, Piano53, Piano54, Piano55, Piano56, Piano57, Piano58, Piano59, Piano60, Piano61, Piano62, Piano63, Piano64, Piano65, Piano66, Piano67, Piano68, Piano69, Piano70, Piano71, Piano72, Piano73, Piano74, Piano75, Piano76, Piano77, Piano78, Piano79, Piano80, Piano81, Piano82, Piano83, Piano84, Piano85, Piano86, Piano87, Piano88, Piano89,Piano90, Piano91, Piano92, Piano93, Piano94, Piano95, Piano96, nil];
    
    NSArray *keysPiano = [NSArray arrayWithObjects: [NSNumber numberWithInteger:24], [NSNumber numberWithInteger:25],[NSNumber numberWithInteger:26],[NSNumber numberWithInteger:27],[NSNumber numberWithInteger:28], [NSNumber numberWithInteger:29],[NSNumber numberWithInteger:30],[NSNumber numberWithInteger:31],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:34], [NSNumber numberWithInteger:35],[NSNumber numberWithInteger:36],[NSNumber numberWithInteger:37],[NSNumber numberWithInteger:38], [NSNumber numberWithInteger:39],[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:41],[NSNumber numberWithInteger:42], [NSNumber numberWithInteger:43],[NSNumber numberWithInteger:44],[NSNumber numberWithInteger:45],[NSNumber numberWithInteger:46], [NSNumber numberWithInteger:47],[NSNumber numberWithInteger:48],[NSNumber numberWithInteger:49],[NSNumber numberWithInteger:50],[NSNumber numberWithInteger:51],[NSNumber numberWithInteger:52], [NSNumber numberWithInteger:53],[NSNumber numberWithInteger:54],[NSNumber numberWithInteger:55],[NSNumber numberWithInteger:56], [NSNumber numberWithInteger:57],[NSNumber numberWithInteger:58],[NSNumber numberWithInteger:59],[NSNumber numberWithInteger:60],[NSNumber numberWithInteger:61],[NSNumber numberWithInteger:62], [NSNumber numberWithInteger:63],[NSNumber numberWithInteger:64],[NSNumber numberWithInteger:65],[NSNumber numberWithInteger:66], [NSNumber numberWithInteger:67],[NSNumber numberWithInteger:68],[NSNumber numberWithInteger:69],[NSNumber numberWithInteger:70],[NSNumber numberWithInteger:71],[NSNumber numberWithInteger:72], [NSNumber numberWithInteger:73],[NSNumber numberWithInteger:74],[NSNumber numberWithInteger:75],[NSNumber numberWithInteger:76], [NSNumber numberWithInteger:77],[NSNumber numberWithInteger:78],[NSNumber numberWithInteger:79], [NSNumber numberWithInteger:80],[NSNumber numberWithInteger:81],[NSNumber numberWithInteger:82], [NSNumber numberWithInteger:83],[NSNumber numberWithInteger:84],[NSNumber numberWithInteger:85],[NSNumber numberWithInteger:86], [NSNumber numberWithInteger:87],[NSNumber numberWithInteger:88],[NSNumber numberWithInteger:89],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:91],[NSNumber numberWithInteger:92], [NSNumber numberWithInteger:93],[NSNumber numberWithInteger:94],[NSNumber numberWithInteger:95],[NSNumber numberWithInteger:96],nil];

        Piano = [NSDictionary dictionaryWithObjects: valuesPiano forKeys: keysPiano];

        // Electric Piano
        EP24 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP24" withExtension:@ "wav"] error:&error];
        [EP24 prepareToPlay];

        EP25 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP25" withExtension:@ "wav"] error:&error];
        [EP25 prepareToPlay];
        
        EP26 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP26" withExtension:@ "wav"] error:&error];
        [EP26 prepareToPlay];
        
        EP27 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP27" withExtension:@ "wav"] error:&error];
        [EP27 prepareToPlay];
        
        EP28 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP28" withExtension:@ "wav"] error:&error];
        [EP28 prepareToPlay];
        
        EP29 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP29" withExtension:@ "wav"] error:&error];
        [EP29 prepareToPlay];
        
        EP30 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP30" withExtension:@ "wav"] error:&error];
        [EP30 prepareToPlay];
        
        EP31 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP31" withExtension:@ "wav"] error:&error];
        [EP31 prepareToPlay];
        
        EP32 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP32" withExtension:@ "wav"] error:&error];
        [EP32 prepareToPlay];
        
        EP33 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP33" withExtension:@ "wav"] error:&error];
        [EP33 prepareToPlay];

        EP34 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP34" withExtension:@ "wav"] error:&error];
        [EP34 prepareToPlay];

        EP35 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP35" withExtension:@ "wav"] error:&error];
        [EP35 prepareToPlay];
        
        EP36 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP36" withExtension:@ "wav"] error:&error];
        [EP36 prepareToPlay];
        
        EP37 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP37" withExtension:@ "wav"] error:&error];
        [EP37 prepareToPlay];
        
        EP38 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP38" withExtension:@ "wav"] error:&error];
        [EP38 prepareToPlay];
        
        EP39 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP39" withExtension:@ "wav"] error:&error];
        [EP39 prepareToPlay];
        
        EP40 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP40" withExtension:@ "wav"] error:&error];
        [EP40 prepareToPlay];
        
        EP41 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP41" withExtension:@ "wav"] error:&error];
        [EP41 prepareToPlay];
        
        EP42 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP42" withExtension:@ "wav"] error:&error];
        [EP42 prepareToPlay];
        
        EP43 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP43" withExtension:@ "wav"] error:&error];
        [EP43 prepareToPlay];

        EP44 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP44" withExtension:@ "wav"] error:&error];
        [EP44 prepareToPlay];

        EP45 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP45" withExtension:@ "wav"] error:&error];
        [EP45 prepareToPlay];

        EP46 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP46" withExtension:@ "wav"] error:&error];
        [EP46 prepareToPlay];

        EP47 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP47" withExtension:@ "wav"] error:&error];
        [EP47 prepareToPlay];

       EP48 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP48" withExtension:@ "wav"] error:&error];
        [EP48 prepareToPlay];

       EP49 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP49" withExtension:@ "wav"] error:&error];
        [EP49 prepareToPlay];

       EP50 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP50" withExtension:@ "wav"] error:&error];
        [EP50 prepareToPlay];

       EP51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP51" withExtension:@ "wav"] error:&error];
        [EP51 prepareToPlay];

       EP52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP51" withExtension:@ "wav"] error:&error];
        [EP52 prepareToPlay];

       EP53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP53" withExtension:@ "wav"] error:&error];
        [EP53 prepareToPlay];

       EP54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP54" withExtension:@ "wav"] error:&error];
        [EP54 prepareToPlay];

       EP55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP55" withExtension:@ "wav"] error:&error];
        [EP55 prepareToPlay];

       EP56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP56" withExtension:@ "wav"] error:&error];
        [EP56 prepareToPlay];

       EP57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP57" withExtension:@ "wav"] error:&error];
        [EP57 prepareToPlay];
        
       EP58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP58" withExtension:@ "wav"] error:&error];
        [EP58 prepareToPlay];

       EP59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP59" withExtension:@ "wav"] error:&error];
        [EP59 prepareToPlay];

       EP60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP60" withExtension:@ "wav"] error:&error];
        [EP60 prepareToPlay];
        
       EP61 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP61" withExtension:@ "wav"] error:&error];
        [EP61 prepareToPlay];
        
       EP62 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP62" withExtension:@ "wav"] error:&error];
        [EP62 prepareToPlay];
        
       EP63 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP63" withExtension:@ "wav"] error:&error];
        [EP63 prepareToPlay];
        
       EP64 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP64" withExtension:@ "wav"] error:&error];
        [EP64 prepareToPlay];
        
       EP65 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP65" withExtension:@ "wav"] error:&error];
        [EP65 prepareToPlay];
        
       EP66 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP66" withExtension:@ "wav"] error:&error];
        [EP66 prepareToPlay];
        
       EP67 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP67" withExtension:@ "wav"] error:&error];
        [EP67 prepareToPlay];
        
       EP68 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP68" withExtension:@ "wav"] error:&error];
        [EP68 prepareToPlay];
        
       EP69 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP69" withExtension:@ "wav"] error:&error];
        [EP69 prepareToPlay];

       EP70 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP70" withExtension:@ "wav"] error:&error];
        [EP70 prepareToPlay];
        
       EP71 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP71" withExtension:@ "wav"] error:&error];
        [EP71 prepareToPlay];
        
       EP72 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP72" withExtension:@ "wav"] error:&error];
        [EP72 prepareToPlay];
        
       EP73 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP73" withExtension:@ "wav"] error:&error];
        [EP73 prepareToPlay];
        
       EP74 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP74" withExtension:@ "wav"] error:&error];
        [EP74 prepareToPlay];
        
       EP75 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP75" withExtension:@ "wav"] error:&error];
        [EP75 prepareToPlay];
        
       EP76 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP76" withExtension:@ "wav"] error:&error];
        [EP76 prepareToPlay];
        
       EP77 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP77" withExtension:@ "wav"] error:&error];
        [EP77 prepareToPlay];
        
       EP78 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP78" withExtension:@ "wav"] error:&error];
        [EP78 prepareToPlay];
        
       EP79 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP79" withExtension:@ "wav"] error:&error];
        [EP79 prepareToPlay];

       EP80 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP80" withExtension:@ "wav"] error:&error];
        [EP80 prepareToPlay];

        
       EP81 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP81" withExtension:@ "wav"] error:&error];
        [EP81 prepareToPlay];
        
       EP82 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP82" withExtension:@ "wav"] error:&error];
        [EP82 prepareToPlay];
        
       EP83 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP83" withExtension:@ "wav"] error:&error];
        [EP83 prepareToPlay];
        
       EP84 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP84" withExtension:@ "wav"] error:&error];
        [EP84 prepareToPlay];
        
       EP85 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP85" withExtension:@ "wav"] error:&error];
        [EP85 prepareToPlay];
        
       EP86 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP86" withExtension:@ "wav"] error:&error];
        [EP86 prepareToPlay];
        
       EP87 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP87" withExtension:@ "wav"] error:&error];
        [EP87 prepareToPlay];
        
       EP88 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP88" withExtension:@ "wav"] error:&error];
        [EP88 prepareToPlay];
        
       EP89 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP89" withExtension:@ "wav"] error:&error];
        [EP89 prepareToPlay];

       EP90 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP90" withExtension:@ "wav"] error:&error];
        [EP90 prepareToPlay];
        
       EP91 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP91" withExtension:@ "wav"] error:&error];
        [EP91 prepareToPlay];
        
       EP92 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP92" withExtension:@ "wav"] error:&error];
        [EP92 prepareToPlay];
        
       EP93 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP93" withExtension:@ "wav"] error:&error];
        [EP93 prepareToPlay];
        
       EP94 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP94" withExtension:@ "wav"] error:&error];
        [EP94 prepareToPlay];
        
       EP95 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP95" withExtension:@ "wav"] error:&error];
        [EP95 prepareToPlay];
        
       EP96 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteEP96" withExtension:@ "wav"] error:&error];
        [EP96 prepareToPlay];
        
     
        // EP dictionary initialization
        NSArray *valuesEP = [NSArray arrayWithObjects: EP24, EP25, EP26, EP27, EP28, EP29, EP30, EP31, EP32, EP33, EP34, EP35, EP36, EP37, EP38, EP39, EP40, EP41, EP42, EP43, EP44, EP45, EP46, EP47, EP48, EP49, EP50, EP51, EP52, EP53, EP54, EP55, EP56, EP57, EP58, EP59, EP60, EP61, EP62, EP63, EP64, EP65, EP66, EP67, EP68, EP69, EP70, EP71, EP72, EP73, EP74, EP75, EP76, EP77, EP78, EP79, EP80, EP81, EP82, EP83, EP84, EP85, EP86, EP87, EP88, EP89,EP90, EP91, EP92, EP93, EP94, EP95, EP96, nil];
        NSLog(@"Number of values: %lu", (unsigned long)[valuesEP count]);
        
        NSArray *keysEP = [NSArray arrayWithObjects:[NSNumber numberWithInteger:24], [NSNumber numberWithInteger:25],[NSNumber numberWithInteger:26],[NSNumber numberWithInteger:27],[NSNumber numberWithInteger:28], [NSNumber numberWithInteger:29],[NSNumber numberWithInteger:30],[NSNumber numberWithInteger:31],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:34], [NSNumber numberWithInteger:35],[NSNumber numberWithInteger:36],[NSNumber numberWithInteger:37],[NSNumber numberWithInteger:38], [NSNumber numberWithInteger:39],[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:41],[NSNumber numberWithInteger:42], [NSNumber numberWithInteger:43],[NSNumber numberWithInteger:44],[NSNumber numberWithInteger:45],[NSNumber numberWithInteger:46], [NSNumber numberWithInteger:47],[NSNumber numberWithInteger:48],[NSNumber numberWithInteger:49],[NSNumber numberWithInteger:50],[NSNumber numberWithInteger:51],[NSNumber numberWithInteger:52], [NSNumber numberWithInteger:53],[NSNumber numberWithInteger:54],[NSNumber numberWithInteger:55],[NSNumber numberWithInteger:56], [NSNumber numberWithInteger:57],[NSNumber numberWithInteger:58],[NSNumber numberWithInteger:59],[NSNumber numberWithInteger:60],[NSNumber numberWithInteger:61],[NSNumber numberWithInteger:62], [NSNumber numberWithInteger:63],[NSNumber numberWithInteger:64],[NSNumber numberWithInteger:65],[NSNumber numberWithInteger:66], [NSNumber numberWithInteger:67],[NSNumber numberWithInteger:68],[NSNumber numberWithInteger:69],[NSNumber numberWithInteger:70],[NSNumber numberWithInteger:71],[NSNumber numberWithInteger:72], [NSNumber numberWithInteger:73],[NSNumber numberWithInteger:74],[NSNumber numberWithInteger:75],[NSNumber numberWithInteger:76], [NSNumber numberWithInteger:77],[NSNumber numberWithInteger:78],[NSNumber numberWithInteger:79], [NSNumber numberWithInteger:80],[NSNumber numberWithInteger:81],[NSNumber numberWithInteger:82], [NSNumber numberWithInteger:83],[NSNumber numberWithInteger:84],[NSNumber numberWithInteger:85],[NSNumber numberWithInteger:86], [NSNumber numberWithInteger:87],[NSNumber numberWithInteger:88],[NSNumber numberWithInteger:89],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:91],[NSNumber numberWithInteger:92], [NSNumber numberWithInteger:93],[NSNumber numberWithInteger:94],[NSNumber numberWithInteger:95],[NSNumber numberWithInteger:96], nil];

            EP = [NSDictionary dictionaryWithObjects: valuesEP forKeys: keysEP];
    
    // Bass and Electric Piano
        BassAndEP24 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP24" withExtension:@ "wav"] error:&error];
        [BassAndEP24 prepareToPlay];

        BassAndEP25 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP25" withExtension:@ "wav"] error:&error];
        [BassAndEP25 prepareToPlay];
        
        BassAndEP26 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP26" withExtension:@ "wav"] error:&error];
        [BassAndEP26 prepareToPlay];
        
        BassAndEP27 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP27" withExtension:@ "wav"] error:&error];
        [BassAndEP27 prepareToPlay];
        
        BassAndEP28 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP28" withExtension:@ "wav"] error:&error];
        [BassAndEP28 prepareToPlay];
        
        BassAndEP29 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP29" withExtension:@ "wav"] error:&error];
        [BassAndEP29 prepareToPlay];
        
        BassAndEP30 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP30" withExtension:@ "wav"] error:&error];
        [BassAndEP30 prepareToPlay];
        
        BassAndEP31 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP31" withExtension:@ "wav"] error:&error];
        [BassAndEP31 prepareToPlay];
        
        BassAndEP32 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP32" withExtension:@ "wav"] error:&error];
        [BassAndEP32 prepareToPlay];
        
        BassAndEP33 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP33" withExtension:@ "wav"] error:&error];
        [BassAndEP33 prepareToPlay];

        BassAndEP34 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP34" withExtension:@ "wav"] error:&error];
        [BassAndEP34 prepareToPlay];

        BassAndEP35 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP35" withExtension:@ "wav"] error:&error];
        [BassAndEP35 prepareToPlay];
        
        BassAndEP36 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP36" withExtension:@ "wav"] error:&error];
        [BassAndEP36 prepareToPlay];
        
        BassAndEP37 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP37" withExtension:@ "wav"] error:&error];
        [BassAndEP37 prepareToPlay];
        
        BassAndEP38 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP38" withExtension:@ "wav"] error:&error];
        [BassAndEP38 prepareToPlay];
        
        BassAndEP39 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP39" withExtension:@ "wav"] error:&error];
        [BassAndEP39 prepareToPlay];
        
        BassAndEP40 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP40" withExtension:@ "wav"] error:&error];
        [BassAndEP40 prepareToPlay];
        
        BassAndEP41 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP41" withExtension:@ "wav"] error:&error];
        [BassAndEP41 prepareToPlay];
        
        BassAndEP42 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP42" withExtension:@ "wav"] error:&error];
        [BassAndEP42 prepareToPlay];
        
        BassAndEP43 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP43" withExtension:@ "wav"] error:&error];
        [BassAndEP43 prepareToPlay];

        BassAndEP44 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP44" withExtension:@ "wav"] error:&error];
        [BassAndEP44 prepareToPlay];

        BassAndEP45 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP45" withExtension:@ "wav"] error:&error];
        [BassAndEP45 prepareToPlay];

        BassAndEP46 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP46" withExtension:@ "wav"] error:&error];
        [BassAndEP46 prepareToPlay];

        BassAndEP47 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP47" withExtension:@ "wav"] error:&error];
        [BassAndEP47 prepareToPlay];

       BassAndEP48 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP48" withExtension:@ "wav"] error:&error];
        [BassAndEP48 prepareToPlay];

       BassAndEP49 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP49" withExtension:@ "wav"] error:&error];
        [BassAndEP49 prepareToPlay];

       BassAndEP50 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP50" withExtension:@ "wav"] error:&error];
        [BassAndEP50 prepareToPlay];

       BassAndEP51 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP51" withExtension:@ "wav"] error:&error];
        [BassAndEP51 prepareToPlay];

       BassAndEP52 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP51" withExtension:@ "wav"] error:&error];
        [BassAndEP52 prepareToPlay];

       BassAndEP53 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP53" withExtension:@ "wav"] error:&error];
        [BassAndEP53 prepareToPlay];

       BassAndEP54 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP54" withExtension:@ "wav"] error:&error];
        [BassAndEP54 prepareToPlay];

       BassAndEP55 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP55" withExtension:@ "wav"] error:&error];
        [BassAndEP55 prepareToPlay];

       BassAndEP56 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP56" withExtension:@ "wav"] error:&error];
        [BassAndEP56 prepareToPlay];

       BassAndEP57 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP57" withExtension:@ "wav"] error:&error];
        [BassAndEP57 prepareToPlay];
        
       BassAndEP58 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP58" withExtension:@ "wav"] error:&error];
        [BassAndEP58 prepareToPlay];

       BassAndEP59 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP59" withExtension:@ "wav"] error:&error];
        [BassAndEP59 prepareToPlay];

       BassAndEP60 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP60" withExtension:@ "wav"] error:&error];
        [BassAndEP60 prepareToPlay];
        
       BassAndEP61 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP61" withExtension:@ "wav"] error:&error];
        [BassAndEP61 prepareToPlay];
        
       BassAndEP62 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP62" withExtension:@ "wav"] error:&error];
        [BassAndEP62 prepareToPlay];
        
       BassAndEP63 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP63" withExtension:@ "wav"] error:&error];
        [BassAndEP63 prepareToPlay];
        
       BassAndEP64 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP64" withExtension:@ "wav"] error:&error];
        [BassAndEP64 prepareToPlay];
        
       BassAndEP65 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP65" withExtension:@ "wav"] error:&error];
        [BassAndEP65 prepareToPlay];
        
       BassAndEP66 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP66" withExtension:@ "wav"] error:&error];
        [BassAndEP66 prepareToPlay];
        
       BassAndEP67 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP67" withExtension:@ "wav"] error:&error];
        [BassAndEP67 prepareToPlay];
        
       BassAndEP68 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP68" withExtension:@ "wav"] error:&error];
        [BassAndEP68 prepareToPlay];
        
       BassAndEP69 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP69" withExtension:@ "wav"] error:&error];
        [BassAndEP69 prepareToPlay];

       BassAndEP70 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP70" withExtension:@ "wav"] error:&error];
        [BassAndEP70 prepareToPlay];
        
       BassAndEP71 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP71" withExtension:@ "wav"] error:&error];
        [BassAndEP71 prepareToPlay];
        
       BassAndEP72 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP72" withExtension:@ "wav"] error:&error];
        [BassAndEP72 prepareToPlay];
        
       BassAndEP73 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP73" withExtension:@ "wav"] error:&error];
        [BassAndEP73 prepareToPlay];
        
       BassAndEP74 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP74" withExtension:@ "wav"] error:&error];
        [BassAndEP74 prepareToPlay];
        
       BassAndEP75 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP75" withExtension:@ "wav"] error:&error];
        [BassAndEP75 prepareToPlay];
        
       BassAndEP76 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP76" withExtension:@ "wav"] error:&error];
        [BassAndEP76 prepareToPlay];
        
       BassAndEP77 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP77" withExtension:@ "wav"] error:&error];
        [BassAndEP77 prepareToPlay];
        
       BassAndEP78 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP78" withExtension:@ "wav"] error:&error];
        [BassAndEP78 prepareToPlay];
        
       BassAndEP79 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP79" withExtension:@ "wav"] error:&error];
        [BassAndEP79 prepareToPlay];

       BassAndEP80 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP80" withExtension:@ "wav"] error:&error];
        [BassAndEP80 prepareToPlay];

        
       BassAndEP81 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP81" withExtension:@ "wav"] error:&error];
        [BassAndEP81 prepareToPlay];
        
       BassAndEP82 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP82" withExtension:@ "wav"] error:&error];
        [BassAndEP82 prepareToPlay];
        
       BassAndEP83 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP83" withExtension:@ "wav"] error:&error];
        [BassAndEP83 prepareToPlay];
        
       BassAndEP84 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP84" withExtension:@ "wav"] error:&error];
        [BassAndEP84 prepareToPlay];
        
       BassAndEP85 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP85" withExtension:@ "wav"] error:&error];
        [BassAndEP85 prepareToPlay];
        
       BassAndEP86 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP86" withExtension:@ "wav"] error:&error];
        [BassAndEP86 prepareToPlay];
        
       BassAndEP87 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP87" withExtension:@ "wav"] error:&error];
        [BassAndEP87 prepareToPlay];
        
       BassAndEP88 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP88" withExtension:@ "wav"] error:&error];
        [BassAndEP88 prepareToPlay];
        
       BassAndEP89 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP89" withExtension:@ "wav"] error:&error];
        [BassAndEP89 prepareToPlay];

       BassAndEP90 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP90" withExtension:@ "wav"] error:&error];
        [BassAndEP90 prepareToPlay];
        
       BassAndEP91 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP91" withExtension:@ "wav"] error:&error];
        [BassAndEP91 prepareToPlay];
        
       BassAndEP92 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP92" withExtension:@ "wav"] error:&error];
        [BassAndEP92 prepareToPlay];
        
       BassAndEP93 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP93" withExtension:@ "wav"] error:&error];
        [BassAndEP93 prepareToPlay];
        
       BassAndEP94 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP94" withExtension:@ "wav"] error:&error];
        [BassAndEP94 prepareToPlay];
        
       BassAndEP95 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP95" withExtension:@ "wav"] error:&error];
        [BassAndEP95 prepareToPlay];
        
       BassAndEP96 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"AndanteBassAndEP96" withExtension:@ "wav"] error:&error];
        [BassAndEP96 prepareToPlay];
        
     
        // EP dictionary initialization
        NSArray *valuesBassAndEP = [NSArray arrayWithObjects: BassAndEP24, BassAndEP25, BassAndEP26, BassAndEP27, BassAndEP28, BassAndEP29, BassAndEP30, BassAndEP31, BassAndEP32, BassAndEP33, BassAndEP34, BassAndEP35, BassAndEP36, BassAndEP37, BassAndEP38, BassAndEP39, BassAndEP40, BassAndEP41, BassAndEP42, BassAndEP43, BassAndEP44, BassAndEP45, BassAndEP46, BassAndEP47, BassAndEP48, BassAndEP49, BassAndEP50, BassAndEP51, BassAndEP52, BassAndEP53, BassAndEP54, BassAndEP55, BassAndEP56, BassAndEP57, BassAndEP58, BassAndEP59, BassAndEP60, BassAndEP61, BassAndEP62, BassAndEP63, BassAndEP64, BassAndEP65, BassAndEP66, BassAndEP67, BassAndEP68, BassAndEP69, BassAndEP70, BassAndEP71, BassAndEP72, BassAndEP73, BassAndEP74, BassAndEP75, BassAndEP76, BassAndEP77, BassAndEP78, BassAndEP79, BassAndEP80, BassAndEP81, BassAndEP82, BassAndEP83, BassAndEP84, BassAndEP85, BassAndEP86, BassAndEP87, BassAndEP88, BassAndEP89,BassAndEP90, BassAndEP91, BassAndEP92, BassAndEP93, BassAndEP94, BassAndEP95, BassAndEP96, nil];
        NSLog(@"Number of values: %lu", (unsigned long)[valuesBassAndEP count]);
        
        NSArray *keysBassAndEP = [NSArray arrayWithObjects:[NSNumber numberWithInteger:24], [NSNumber numberWithInteger:25],[NSNumber numberWithInteger:26],[NSNumber numberWithInteger:27],[NSNumber numberWithInteger:28], [NSNumber numberWithInteger:29],[NSNumber numberWithInteger:30],[NSNumber numberWithInteger:31],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:34], [NSNumber numberWithInteger:35],[NSNumber numberWithInteger:36],[NSNumber numberWithInteger:37],[NSNumber numberWithInteger:38], [NSNumber numberWithInteger:39],[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:41],[NSNumber numberWithInteger:42], [NSNumber numberWithInteger:43],[NSNumber numberWithInteger:44],[NSNumber numberWithInteger:45],[NSNumber numberWithInteger:46], [NSNumber numberWithInteger:47],[NSNumber numberWithInteger:48],[NSNumber numberWithInteger:49],[NSNumber numberWithInteger:50],[NSNumber numberWithInteger:51],[NSNumber numberWithInteger:52], [NSNumber numberWithInteger:53],[NSNumber numberWithInteger:54],[NSNumber numberWithInteger:55],[NSNumber numberWithInteger:56], [NSNumber numberWithInteger:57],[NSNumber numberWithInteger:58],[NSNumber numberWithInteger:59],[NSNumber numberWithInteger:60],[NSNumber numberWithInteger:61],[NSNumber numberWithInteger:62], [NSNumber numberWithInteger:63],[NSNumber numberWithInteger:64],[NSNumber numberWithInteger:65],[NSNumber numberWithInteger:66], [NSNumber numberWithInteger:67],[NSNumber numberWithInteger:68],[NSNumber numberWithInteger:69],[NSNumber numberWithInteger:70],[NSNumber numberWithInteger:71],[NSNumber numberWithInteger:72], [NSNumber numberWithInteger:73],[NSNumber numberWithInteger:74],[NSNumber numberWithInteger:75],[NSNumber numberWithInteger:76], [NSNumber numberWithInteger:77],[NSNumber numberWithInteger:78],[NSNumber numberWithInteger:79], [NSNumber numberWithInteger:80],[NSNumber numberWithInteger:81],[NSNumber numberWithInteger:82], [NSNumber numberWithInteger:83],[NSNumber numberWithInteger:84],[NSNumber numberWithInteger:85],[NSNumber numberWithInteger:86], [NSNumber numberWithInteger:87],[NSNumber numberWithInteger:88],[NSNumber numberWithInteger:89],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:91],[NSNumber numberWithInteger:92], [NSNumber numberWithInteger:93],[NSNumber numberWithInteger:94],[NSNumber numberWithInteger:95],[NSNumber numberWithInteger:96], nil];

            BassAndEP = [NSDictionary dictionaryWithObjects: valuesBassAndEP forKeys: keysBassAndEP];
    
    
        // Sound Effects
        Ding = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Ding" withExtension:@ "wav"] error:&error];
         [Ding prepareToPlay];
}
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
    if (pickerView == _picker) {
        return _pickerData.count;
    }
    if (pickerView == _genrePicker) {
        return _genrePickerData.count;
     }
    else {
        return _drumPickerData.count;
    }
 }

// The data to return for the row and component (column) that's being passed in
 - (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
    if (pickerView == _picker) {
        return _pickerData[row];
    }
    if (pickerView == _genrePicker) {
        return _genrePickerData[row];
    }
    else {
        return _drumPickerData[row];
    }
 }


// Do something with the selected row
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _picker) {
        _bleDevice = [_pickerData objectAtIndex: row];
        NSLog(@"You selected this: %@", _bleDevice);
    }
    if (pickerView == _genrePicker) {
        switch(row) {
                case 0:
                instrument = @"Piano";
                   // [_genrePicker isEqual: @"Piano"];
                    break;
                case 1:
                instrument = @"Bass";
                   // [_genrePicker isEqual: @"Bass"];
                    break;
                case 2:
                instrument = @"Electric Piano";
                    //[_genrePicker isEqual: @"Electric Piano"];
                    break;
        }
    }
    if (pickerView == _drumPicker) {
        switch(row) {
                case 0:
                drumKit = @"Acoustic";
                   // [_genrePicker isEqual: @"Piano"];
                    break;
                case 1:
                drumKit = @"Trap";
                   // [_genrePicker isEqual: @"Bass"];
                    break;
        }
    }
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

// Also moved this up
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)modeChange:(id)sender {
    if (_modeSwitch.on) {
         modeToe = false;
        _modeLabel.text = @"Stance Phase";
    }
    else {
         modeToe = true;
        _modeLabel.text = @"Swing Phase";
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    
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

    if (modeToe == false) { // Heel Mode
       // [Piano44 play];
        
        
        [theLock lock];
        
        // Music code!
        
        // footswitch + knee brace (or just footswitch), chords+drums+detune
        
        // initial parameters (do elsewhere?)
       // dspFaust->setParamValue("hat_gain", .8);
      //  dspFaust->setParamValue("snare_gain", .9);
     //   dspFaust->setParamValue("kick_gain", .9);
        //dspFaust->setParamValue("kick_freq", 100);
        //dspFaust->setParamValue("detune", 0.5);
      //  dspFaust->setParamValue("kick_gate", 0);
        dspFaust->setParamValue("detune", detuneAmount);
        
        
        if ([peripheral.name containsString:_kneeDeviceName]) {
            // Control changes
            if (vals[2] == 176){
             //   currentDetune = vals[0]/100.0f; // Melissa: maybe change denom to be slider value?
                currentDetune = vals[0]/globalMaxDetune; // Melissa: check this
                detuneAmount = currentDetune;
            }
        }
        else if ([peripheral.name containsString:_footDeviceName]) {
            // Play music
            // noteOn
            if (vals[2] == 144){
                // drums
                /*
                
                if (vals[1] == 3){
                    //dspFaust->setParamValue("kick_gate", 1);
                    AcousticKick.currentTime = 0;
                    [AcousticKick play];
                }
                else if (vals[1] == 1){
                    //dspFaust->setParamValue("snare_gate", 1);
                    AcousticSnare.currentTime = 0;
                    [AcousticSnare play];
                }
                else if (vals[1] == 2){
                    //dspFaust->setParamValue("hat_gate", 1);
                    AcousticHat.currentTime = 0;
                    [AcousticHat play];
                }
                 */
                
                // chord synth
                //else{
                    [self playNote:vals[1]];
                    //dspFaust->keyOn(vals[1], vals[0]);
               // }
                //NSLog(@"MIDI int #2: %d", vals[1]);
                
                // dspFaust->setParamValue("synth_midi", vals[1]);
                // dspFaust->setParamValue("synth_gate", 1);
                
                // implement velocity -> gain later
            }

            // noteOff
            
            // Melissa just changed!
            /*
            if (vals[2] == 128){
                // drums
                if (vals[1] == 3){
                    //dspFaust->setParamValue("kick_gate", 0);
                    [AcousticKick pause];
                }
                else if (vals[1] == 1){
                    dspFaust->setParamValue("snare_gate", 0);
                    [AcousticSnare pause];
                }
                else if (vals[1] == 2){
                    dspFaust->setParamValue("hat_gate", 0);
                    [AcousticHat pause];
                }
                
                // chord synth
                else{
                    dspFaust->keyOff(vals[1]);
                    }
                */
                
                // dspFaust->setParamValue("synth_midi", vals[1]);
                // dspFaust->setParamValue("synth_gate", 0);
                // problematic; shuts all off if one key is off; learn multi-channel midi later
                //}
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
        }*/
    
        [theLock unlock];
        
        
        
    }
    else { // Toe off mode
        if (vals[2] == 144) {
            switch (state) {
                 case TOE_OFF:
                 {
                     // swing phase
                     if ([peripheral.name containsString:_kneeDeviceName]) {
                         if (vals[1] >= kneeStanceAvg + KNEE_DIFF_THRESH) {
                             tonicChange = true;
                         }
                         //NSLog(@"Knee angle = %d", vals[1]);
                         //NSLog(@"kneeStanceAvg = %d", kneeStanceAvg);
                     } else if ([peripheral.name containsString:_footDeviceName]) {
                         if (vals[1] == HEEL_STRIKE) {
                             state = HEEL_STRIKE;
                             kneeStanceAvg = 0;
                             numStanceAvg = 0;
                             if (tonicChange && vals[0] != CALIBRATION) {
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
                     if ([peripheral.name containsString:_kneeDeviceName]) {
                         kneeStanceAvg += vals[1];
                         numStanceAvg++;
                     } else if ([peripheral.name containsString:_footDeviceName]) {
                         if (vals[1] == TOE_OFF) {
                             state = TOE_OFF;
                             kneeStanceAvg /= numStanceAvg;
                         }
                     }
                     break;
                 }
             }
        }

         [theLock lock];
        if ([peripheral.name containsString:_footDeviceName] && vals[2] == 144){
            if (vals[1] == PLAY_SNARE) {
                if([drumKit isEqual:@"Acoustic"]) {
                    AcousticSnare.currentTime = 0;
                    [AcousticSnare setVolume:0.5];
                    [AcousticSnare play];
                }
                else if([drumKit isEqual:@"Trap"]) {
                    TrapSnare.currentTime = 0;
                    [TrapSnare setVolume:0.5];
                    [TrapSnare play];
                }
            }
            if (vals[1] == PLAY_KICK) {
                if([drumKit isEqual:@"Acoustic"]) {
                    AcousticKick.currentTime = 0;
                    [AcousticKick setVolume:0.5];
                    [AcousticKick play];
                }
                else if([drumKit isEqual:@"Trap"]) {
                    TrapKick.currentTime = 0;
                    [TrapKick setVolume:0.5];
                    [TrapKick play];
                }
            }
            else if (vals[1] == PLAY_HAT) {
                if([drumKit isEqual:@"Acoustic"]) {
                    AcousticHat.currentTime = 0;
                    [AcousticHat setVolume:0.5];
                    [AcousticHat play];
                }
                else if([drumKit isEqual:@"Trap"]) {
                    TrapHat.currentTime = 0;
                    [TrapHat setVolume:0.5];
                    [TrapHat play];
                }
  
            } else {
                [self playNote:(circleOf5ths[tonicIdx] + vals[1])];
                 NSLog(@"MIDI int: %d", vals[1]);
                NSLog(@"MIDI int: %d", vals[1]);
                if (vals[1] == 0 || vals[1] == 5 || vals[1] == 7) {
                    if([drumKit isEqual:@"Acoustic"]) {
                        AcousticKick.currentTime = 0;
                        [AcousticKick play];
                    }
                    else { // drumKit is Trap
                        TrapKick.currentTime = 0;
                        [TrapKick play];
                        
                    }
                }
                if([drumKit isEqual:@"Acoustic"]) {
                    AcousticHat.currentTime = 0;
                    [AcousticHat play];
                }
                else {
                    TrapHat.currentTime = 0;
                    [TrapHat play];
                }
            }
            
            // stop all notes except tonic
            if (vals[1] == 12) {
                for (int i = 0; i < 12; i++) {
                    [self stopNote:(circleOf5ths[tonicIdx] + i)];
                }
            }
        }
         else if ([peripheral.name containsString:_footDeviceName] && vals[2] == 128){
             //[self stopNote:(circleOf5ths[tonicIdx] + vals[1])];
         }
         [theLock unlock];
        
    }
}

- (IBAction)connectWasPressed:(id)sender {
    for (int i = 0; i < [_devices count]; i++) {
        CBPeripheral *peripheral = [_devices objectAtIndex:i];
        if ([peripheral.name isEqualToString:_bleDevice]) {
            [_myManager connectPeripheral:peripheral options:nil];
            [_currInstrumentTextField setText:[@"Connected: " stringByAppendingString:_bleDevice]];
            // should solve issue of two buttons overlapping
            Ding.currentTime = 0;
            [Ding play];
            [_currInstrumentTextField setHidden:NO];
        }
    }
}

- (IBAction)detune:(id)sender {
    dspFaust->setParamValue("detune", _slider.value*0.20);
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
    self.tfValue.text = [NSString stringWithFormat:@"%f", _slider.value];
    int detuneAmount = _slider.value*0.20; // 0.25 best so far
    dspFaust->setParamValue("detune", detuneAmount);
    globalMaxDetune = detuneAmount;
    // slider value is currently from 1 to 100, can change
    // then need to connect this back to old stuff***
}

-(IBAction)playChord:(id)sender {
    const int SR = 44100;
    const int bufferSize = 256;
    dspFaust = new DspFaust(SR,bufferSize);
    dspFaust->start();
    dspFaust->setParamValue("detune", _slider.value*0.20);
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
}

-(IBAction)stopChord:(id)sender {
    dspFaust->keyOff(40);
    dspFaust->keyOff(44);
    dspFaust->keyOff(47);
    dspFaust->stop();
}


- (void) playNote: (int) midi {
    if(midi <= 2) { // MIDI is DRUM
        if([drumKit isEqual: @"Acoustic"]) {
            [self playAcoustic:midi];
        }
        else if([drumKit isEqual: @"Trap"]) {
            [self playTrap:midi];
        }
    }
    else { // MIDI is Instrument
        if([instrument isEqual:@"Piano"]) {
            [self playPiano:midi];
        }
       // if([_genrePicker isEqual: @"Bass"]) {
        if([instrument isEqual:@"Bass"]) {
            [self playBassAndEP:midi];
        }
      //  if([_genrePicker isEqual: @"Electric Piano"]) {
        if([instrument isEqual:@"Electric Piano"]) {
            [self playEP:midi];
        }
    }
}

- (void) stopNote: (int) midi {
    if(genreBass == true) {
        AVAudioPlayer *key = BassAndEP[[NSNumber numberWithInteger: midi]];
        [key stop];
    }
    else {
        AVAudioPlayer *key = Piano[[NSNumber numberWithInteger: midi]];
        NSTimeInterval t = 0.2;
        //[key setVolume:0 fadeDuration:t];
        [key stop];
    }
}

- (void) playPiano: (int) midi {
    AVAudioPlayer *key = Piano[[NSNumber numberWithInteger: midi]];
    key.currentTime = 0;
    [key play];
    
}

- (void) playEP: (int) midi {
    AVAudioPlayer *key = EP[[NSNumber numberWithInteger: midi]];
    key.currentTime = 0;
    [key play];
}

- (void) playBassAndEP: (int) midi {
    AVAudioPlayer *key = BassAndEP[[NSNumber numberWithInteger: midi]];
    key.currentTime = 0;
    [key play];
}

- (void) playAcoustic: (int) midi {
    AVAudioPlayer *key = Acoustic[[NSNumber numberWithInteger: midi]];
    key.currentTime = 0;
    [key setVolume:0.5]; // Just added
    [key play];
}

- (void) playTrap: (int) midi {
    AVAudioPlayer *key = Trap[[NSNumber numberWithInteger: midi]];
    key.currentTime = 0;
    [key setVolume:0.5];
    [key play];
}

NSInteger midi = 24;

// Remove later, for our own checking
- (IBAction)buttonPressed:(id)sender {
    [self playNote:midi];
    if(midi+1 < 97) {
        midi = midi+1;
    }
}

// Added below method
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // added for SoundFonts
                                    
    // dspFaust->stop();
    // delete dspFaust;
}

@end

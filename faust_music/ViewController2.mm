//
//  ViewController2.m
//  faust_music
//
//  Created by Melissa Marable on 5/14/21.
//

#import "ViewController2.h"
#import "DspFaust.h"

@interface ViewController2 ()

@end

@implementation ViewController2 {
    DspFaust *dspFaust;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    const int SR = 44100;
    const int bufferSize = 256;
       
     dspFaust = new DspFaust(SR,bufferSize);
     dspFaust->start();
    
}
-(IBAction)playChord:(id)sender {
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
}

- (IBAction)detune:(id)sender {
    dspFaust->keyOff(40);
      dspFaust->keyOff(44);
      dspFaust->keyOff(47);
   // dspFaust->keyOn(40, 100);
   // dspFaust->keyOn(44, 100);
   // dspFaust->keyOn(47, 100);
    
    self.tfValue.text = [NSString stringWithFormat:@"%f", _slider.value];
    int detuneAmount = _slider.value*0.20; // 0.25 best so far
    dspFaust->setParamValue("detune", detuneAmount);
    globalMaxDetune = detuneAmount;
    
    // slider value is currently from 1 to 100, can change
    // then need to connect this back to old stuff***
}


- (IBAction)Home:(id)sender {
   // dspFaust->keyOff(40);
   // dspFaust->keyOff(44);
   // dspFaust->keyOff(47);
    dspFaust->stop();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

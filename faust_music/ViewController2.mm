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

int globalMaxDetune = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    const int SR = 44100;
    const int bufferSize = 256;
       
     dspFaust = new DspFaust(SR,bufferSize);
     dspFaust->start();
    
    // slider will begin at the value you previously set it to
    _slider.value = globalMaxDetune/0.20; // change constants later (the 0.2)
    self.tfValue.text = [NSString stringWithFormat:@"%f", _slider.value];
    
    // Chord will play upon entry to ViewController2
    dspFaust->setParamValue("detune", _slider.value*0.20);
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
}

-(IBAction)playChord:(id)sender {
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
}

- (IBAction)detune:(id)sender {
    self.tfValue.text = [NSString stringWithFormat:@"%f", _slider.value];
    int detuneAmount = _slider.value*0.20; // 0.25 best so far
    dspFaust->setParamValue("detune", detuneAmount);
    globalMaxDetune = detuneAmount;
    // slider value is currently from 1 to 100, can change
    // then need to connect this back to old stuff***
}


- (IBAction)Home:(id)sender {
    dspFaust->stop();
}
/*
-(IBAction)myUnwindAction:(UIStoryboardSegue*)unwindSegue {
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

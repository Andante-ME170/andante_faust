//
//  ViewController3.m
//  faust_music
//
//  Created by Melissa Marable on 5/14/21.
//

#import "ViewController3.h"
#import "DspFaust.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController3 ()


@end

@implementation ViewController3 {
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
- (IBAction)Trap:(id)sender {
    dspFaust->keyOn(40, 100);
    dspFaust->keyOn(44, 100);
    dspFaust->keyOn(47, 100);
}
- (IBAction)RandomSounds:(id)sender {
    dspFaust->keyOn(60, 100);
    dspFaust->keyOn(64, 100);
    dspFaust->keyOn(67, 100);
}
- (IBAction)Songs:(id)sender {
    dspFaust->keyOn(80, 100);
    dspFaust->keyOn(84, 100);
    dspFaust->keyOn(87, 100);
}
- (IBAction)stopMusic:(id)sender {
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

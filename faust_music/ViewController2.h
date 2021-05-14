//
//  ViewController2.h
//  faust_music
//
//  Created by Melissa Marable on 5/14/21.
//

#import <UIKit/UIKit.h>
#import "DspFaust.h"


@interface ViewController2 : UIViewController

extern int globalMaxDetune = 100;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)detune:(id)sender;


@end


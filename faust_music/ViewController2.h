//
//  ViewController2.h
//  faust_music
//
//  Created by Melissa Marable on 5/14/21.
//

#import <UIKit/UIKit.h>
#import "DspFaust.h"

extern int globalMaxDetune;

@interface ViewController2 : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfValue;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)detune:(id)sender;

@end


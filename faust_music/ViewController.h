//
//  ViewController.h
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "ViewController3.h"

//extern int globalMaxDetune = 100; // global variable for detuning
extern BOOL modeToe;

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *genreValue;

@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *genreSwitch;

@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

@end




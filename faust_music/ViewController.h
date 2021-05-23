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

@end




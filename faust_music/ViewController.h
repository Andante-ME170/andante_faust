//
//  ViewController.h
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

//extern int globalMaxDetune = 100; // global variable for detuning

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *genreValue;

@end




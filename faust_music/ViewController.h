//
//  ViewController.h
//  faust_music
//
//  Created by Kevin Supakkul on 4/10/21.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end


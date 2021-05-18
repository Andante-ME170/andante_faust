//
//  ViewController3.m
//  faust_music
//
//  Created by Melissa Marable on 5/14/21.
//

#import <UIKit/UIKit.h>
#import "ViewController3.h"
#import "DspFaust.h"
#import <Foundation/Foundation.h>
// #import "ViewController.h"

@interface ViewController3 ()
//@property (nonatomic, strong) NSMutableArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
//@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation ViewController3 {
    DspFaust *dspFaust;
}

int Globalgenre = -1; // Initialization of Global Variable
NSString *g;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    const int SR = 44100;
    const int bufferSize = 256;
       
     dspFaust = new DspFaust(SR,bufferSize);
     dspFaust->start();
    
    _picker.dataSource = self;
    _picker.delegate = self;
}

// The number of columns of data
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
     return 1;
 }

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView  numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

 // The data to return for the row and component (column) that's being passed in
 - (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     NSString * title = nil;
         switch(row) {
                 case 0:
                     title = @"Minor Chord";
                     Globalgenre = 0;
                     break;
                 case 1:
                     title = @"Random Sounds";
                     Globalgenre = 1;
                     break;
                 case 2:
                     title = @"Songs";
                     Globalgenre = 2;
                     break;
         }
         return title;
 }
 
 // Do something with the selected row
//-(void)pickerView:(UIPickerView *)genrePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { //{
  //  g = [_pickerData objectAtIndex: row];
   // NSLog(@"You selected this: %@", _bleDevice);
 //}
 
- (IBAction)PlayGenre:(id)sender {
    switch(Globalgenre) {
        case 0:
            dspFaust->keyOff(60);
            dspFaust->keyOff(64);
            dspFaust->keyOff(67);
            dspFaust->keyOff(80);
            dspFaust->keyOff(84);
            dspFaust->keyOff(87);
            dspFaust->keyOn(40, 100);
            dspFaust->keyOn(44, 100);
            dspFaust->keyOn(47, 100);
            break;
        case 1:
            dspFaust->keyOff(40);
            dspFaust->keyOff(44);
            dspFaust->keyOff(47);
            dspFaust->keyOff(80);
            dspFaust->keyOff(84);
            dspFaust->keyOff(87);
            dspFaust->keyOn(60, 100);
            dspFaust->keyOn(64, 100);
            dspFaust->keyOn(67, 100);
            break;
        case 2:
            dspFaust->keyOff(40);
            dspFaust->keyOff(44);
            dspFaust->keyOff(47);
            dspFaust->keyOff(60);
            dspFaust->keyOff(64);
            dspFaust->keyOff(67);
            dspFaust->keyOn(80, 100);
            dspFaust->keyOn(84, 100);
            dspFaust->keyOn(87, 100);
            break;
    }
}

-(IBAction)stopMusic:(id)sender {
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

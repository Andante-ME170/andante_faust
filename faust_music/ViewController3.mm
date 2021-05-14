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

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetailSegue"]){
        ViewController3 *controller = (ViewController3 *)segue.destinationViewController;
        controller.genreTrap = YES;
    }
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

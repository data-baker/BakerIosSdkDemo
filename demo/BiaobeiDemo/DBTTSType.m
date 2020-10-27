//
//  DBTTSType.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/10/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "DBTTSType.h"
#import "DBTTSNoPlayer.h"
#import "DBTTSVC.h"

@interface DBTTSType ()

@end

@implementation DBTTSType

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"语音合成";
}
- (IBAction)noPlayer:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBTTSNoPlayer *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBTTSNoPlayer"];
    vc.synthesizerManager = self.synthesizerManager;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)havePlayer:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBTTSVC* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ttsDemo"];
    tts.synthesizerManager = self.synthesizerManager;
    [self.navigationController pushViewController:tts animated:YES];
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

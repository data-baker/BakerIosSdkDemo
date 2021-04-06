//
//  DBTTSType.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/10/19.
//  Copyright BiaoBei © 2020 biaobei. All rights reserved.
//

#import "DBTTSType.h"
#import "DBTTSVC.h"
#import "DBTTSNoPlayer.h"

@interface DBTTSType ()

@end

@implementation DBTTSType

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"语音合成";
}
- (IBAction)noPlayer:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBTTSNoPlayer* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"DBTTSNoPlayer"];
    [self.navigationController pushViewController:tts animated:YES];
    
}
- (IBAction)havePlayer:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBTTSVC* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ttsDemo"];
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

//
//  ViewController.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright BiaoBei © 2020 biaobei. All rights reserved.
//

#import "ViewController.h"
#import "DBAuthorizationVC.h"

#import "DBTTSType.h"
#import "DBASRVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标贝demo";
}

- (IBAction)ttsClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *TTSclientId = [defaults valueForKey:@"TTSclientId"];
    NSString *TTSclientSecret = [defaults valueForKey:@"TTSclientSecret"];
    
    if (TTSclientId && TTSclientSecret) {
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DBTTSType* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"DBTTSType"];
        [self.navigationController pushViewController:tts animated:YES];
        
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DBAuthorizationVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBAuthorizationVC"];
        vc.type = DBDemoTypeTTS;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (IBAction)asrClicked:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ASRClientId = [defaults valueForKey:@"ASRclientId"];
    NSString *ASRClientSecret = [defaults valueForKey:@"ASRclientSecret"];
    if (ASRClientId && ASRClientSecret) {
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DBASRVC* asr = [secondStoryBoard instantiateViewControllerWithIdentifier:@"asrDemo"];
        [self.navigationController pushViewController:asr animated:YES];
        
        
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DBAuthorizationVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBAuthorizationVC"];
        vc.type = DBDemoTypeASR;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}





@end

//
//  DBAuthorizationVC.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright BiaoBei © 2020 biaobei. All rights reserved.
//

#import "DBAuthorizationVC.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import "DBTTSType.h"
#import <DBASRFramework/DBRecognitionManager.h>
#import "DBASRVC.h"
#import "XCHudHelper.h"

@interface DBAuthorizationVC ()
@property (weak, nonatomic) IBOutlet UITextField *clientIdText;
@property (weak, nonatomic) IBOutlet UITextField *clientSecretText;
@property (weak, nonatomic) IBOutlet UIButton *authorizationBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLab;

/// 语音合成器
@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;

/// 语音识别器
@property(nonatomic,strong)DBRecognitionManager * recognitionManager;

@end

@implementation DBAuthorizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
 
    
    self.title = @"授权";
    
    if (self.type == DBDemoTypeTTS) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *TTSclientId = [defaults valueForKey:@"TTSclientId"];
        NSString *TTSclientSecret = [defaults valueForKey:@"TTSclientSecret"];
        if (TTSclientId) {
            self.clientIdText.text = TTSclientId;
            self.clientSecretText.text = TTSclientSecret;
        }
        [self.authorizationBtn addTarget:self action:@selector(gotoTTS) forControlEvents:UIControlEventTouchUpInside];
    }else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *TTSclientId = [defaults valueForKey:@"ASRclientId"];
        NSString *TTSclientSecret = [defaults valueForKey:@"ASRclientSecret"];
        if (TTSclientId) {
            self.clientIdText.text = TTSclientId;
            self.clientSecretText.text = TTSclientSecret;
        }
        [self.authorizationBtn addTarget:self action:@selector(gotoASR) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)gotoTTS {
    
    if (self.clientIdText.text.length <= 0 || self.clientSecretText.text.length <= 0) {
        return;
    }
    
    self.synthesizerManager = [[DBSynthesizerManager alloc]init];
    [[XCHudHelper sharedInstance] showHudOnView:self.view caption:@"" image:nil acitivity:YES autoHideTime:0];
    
    [self.synthesizerManager setupClientId:self.clientIdText.text clientSecret:self.clientSecretText.text handler:^(BOOL ret, NSString *message) {
        [[XCHudHelper sharedInstance] hideHud];

        if (ret) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.clientIdText.text forKey:@"TTSclientId"];
            [userDefaults setValue:self.clientSecretText.text forKey:@"TTSclientSecret"];
            [userDefaults synchronize];
            NSLog(@"鉴权成功");
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DBTTSType* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"DBTTSType"];
            [self.navigationController pushViewController:tts animated:YES];

        }else {
            self.errorLab.hidden = NO;
        }
    }];
}

- (void)gotoASR {
    
    if (self.clientIdText.text.length <= 0 || self.clientSecretText.text.length <= 0) {
        return;
    }
    self.recognitionManager = [DBRecognitionManager sharedInstance];
    [[XCHudHelper sharedInstance] showHudOnView:self.view caption:@"" image:nil acitivity:YES autoHideTime:0];

    [self.recognitionManager setupClientId:self.clientIdText.text clientSecret:self.clientSecretText.text failureHandler:^(BOOL ret, NSString * _Nonnull message) {
        [[XCHudHelper sharedInstance] hideHud];

        if (ret) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.clientIdText.text forKey:@"ASRclientId"];
            [userDefaults setValue:self.clientSecretText.text forKey:@"ASRclientSecret"];
            [userDefaults synchronize];
            NSLog(@"鉴权成功");
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DBASRVC* asr = [secondStoryBoard instantiateViewControllerWithIdentifier:@"asrDemo"];
            [self.navigationController pushViewController:asr animated:YES];
        }else {
            self.errorLab.hidden = NO;
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

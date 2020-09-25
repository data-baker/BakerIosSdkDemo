//
//  DBAuthorizationVC.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "DBAuthorizationVC.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import "DBTTSVC.h"
#import <DBASRFramework/DBRecognitionManager.h>
#import "DBASRVC.h"
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
    // Do any additional setup after loading the view.
    
    if (self.type == DBDemoTypeTTS) {
        self.clientIdText.text = @"e2d17fce-f69a-4b78-bbe5-7fef824a77c2";
        self.clientSecretText.text = @"ZTZlOTMyMzAtMThlZS00M2ZjLWJhMTktYTQ2NjBhZTE3Yzk0";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *TTSclientId = [defaults valueForKey:@"TTSclientId"];
        NSString *TTSclientSecret = [defaults valueForKey:@"TTSclientSecret"];
        if (TTSclientId) {
            self.clientIdText.text = TTSclientId;
            self.clientSecretText.text = TTSclientSecret;
        }
        [self.authorizationBtn addTarget:self action:@selector(gotoTTS) forControlEvents:UIControlEventTouchUpInside];
    }else {
        self.clientIdText.text = @"3187ba62-e58d-4bf7-b7be-71252b6d4612";
        self.clientSecretText.text = @"MmMzNTA2YTMtZjUyOC00MjcxLTg5ZTItMGMxNjQxOGM4ZGVm";
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
    
    self.synthesizerManager = [[DBSynthesizerManager alloc]init];;
    [self.synthesizerManager setupClientId:self.clientIdText.text clientSecret:self.clientSecretText.text handler:^(BOOL ret, NSString *message) {
        if (ret) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.clientIdText.text forKey:@"TTSclientId"];
            [userDefaults setValue:self.clientSecretText.text forKey:@"TTSclientSecret"];
            [userDefaults synchronize];
            NSLog(@"鉴权成功");
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DBTTSVC* tts = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ttsDemo"];
            tts.synthesizerManager = self.synthesizerManager;
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
    [self.recognitionManager setupClientId:self.clientIdText.text clientSecret:self.clientSecretText.text failureHandler:^(BOOL ret, NSString * _Nonnull message) {
        if (ret) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.clientIdText.text forKey:@"ASRclientId"];
            [userDefaults setValue:self.clientSecretText.text forKey:@"ASRclientSecret"];
            [userDefaults synchronize];
            NSLog(@"鉴权成功");
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DBASRVC* asr = [secondStoryBoard instantiateViewControllerWithIdentifier:@"asrDemo"];
            asr.recognitionManager = self.recognitionManager;
            [self.navigationController pushViewController:asr animated:YES];
        }else {
            self.errorLab.hidden = NO;
        }
    }];
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

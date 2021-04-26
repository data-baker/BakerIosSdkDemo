//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright BiaoBei © 2017年 newbike. All rights reserved.
//

#import "DBTTSVC.h"
#import <DBFlowTTS/DBSynthesizerManager.h>

NSString * textViewText = @"标贝（北京）科技有限公司专注于智能语音交互，包括语音合成整体解决方案，并提供语音合成、语音识别、图像识别等人工智能数据服务 。帮助客户实现数据价值，以推动技术、应用和产业的创新 。帮助企业盘活大数据资源，挖掘数据中有价值的信息  。主要提供智能语音交互相关服务，包括语音合成整体解决方案，以及语音合成、语音识别、图像识别等人工智能数据服务。 标贝科技在范围内有数据采集、处理团队，可以满足在不同地区收集数据的需求。以语音数据为例，可采集、加工普通话、英语、粤语、日语、韩语及方言等各类数据，以支持客户进行语音合成或者语音识别系统的研发工作。";

@interface DBTTSVC ()<DBSynthesizerManagerDelegate,DBSynthesisPlayerDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;


@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;

@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;


@end

@implementation DBTTSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"语音合成在线";
    
    self.textString = [textViewText mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = textViewText;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *TTSclientId = [defaults valueForKey:@"TTSclientId"];
    NSString *TTSclientSecret = [defaults valueForKey:@"TTSclientSecret"];
    
    _synthesizerManager = [[DBSynthesizerManager alloc]init];
// MARK: ---------------- 1.公有云设置ClientId和ClientSecret; 2.私有云设置setupPrivateDeploymentURL：的URL来进行鉴权
    // TODO: 请设置ClientId和ClientSecret 处理回调
    [_synthesizerManager setupClientId:TTSclientId clientSecret:TTSclientSecret handler:^(BOOL ret, NSString * _Nonnull message) {
        NSLog(@"ret:%@,message:%@",@(ret),message);
        if (ret) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:TTSclientId forKey:@"TTSclientId"];
            [userDefaults setValue:TTSclientSecret forKey:@"TTSclientSecret"];
            [userDefaults synchronize];
            NSLog(@"鉴权成功");
        }
    }];

    //设置打印日志
    _synthesizerManager.log = NO;
    // 设置合成的回调代理对象
    _synthesizerManager.delegate = self;
    // 设置合成播放的回调代理对象
    _synthesizerManager.playerDelegate = self;
}

// MARK: IBActions

- (IBAction)startAction:(id)sender {
    // 先清除之前的数据
    [self resetPlayState];
    self.displayTextView.text = @"";
    if (!self.synthesizerPara) {
        self.synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    self.synthesizerPara.text = self.textView.text;
    self.synthesizerPara.voice = @"标准合成_模仿儿童_果子";
    
    // 设置合成参数
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code == 0) {
        // 开始合成
        [self.synthesizerManager startPlayNeedSpeaker:YES];
    }

}
- (IBAction)closeAction:(id)sender {
    [self.synthesizerManager cancel];
    [self resetPlayState];
    self.displayTextView.text = @"";

}
///  重置播放器播放控制状态
- (void)resetPlayState {
    if (self.playButton.isSelected) {
        self.playButton.selected = NO;
    }
}

- (IBAction)playAction:(UIButton *)sender {
    
    if (self.synthesizerManager.isPlayerPlaying == NO) {
        [self.synthesizerManager resumePlay];
    }else {
        [self.synthesizerManager pausePlay];
    }
}
- (IBAction)currentPlayPosition:(id)sender {
    NSString *position = [NSString stringWithFormat:@"播放进度 %@",[self timeDataWithTimeCount:self.synthesizerManager.currentPlayPosition]];
    [self appendLogMessage:position];
}
- (IBAction)getAudioLength:(id)sender {
    NSString *audioLength = [NSString stringWithFormat:@"音频数据总长度 %@",[self timeDataWithTimeCount:self.synthesizerManager.audioLength]];
    [self appendLogMessage:audioLength];
}
- (IBAction)playState:(id)sender {
    NSString *message;
    if (self.synthesizerManager.isPlayerPlaying) {
        message = @"正在播放";
    }else {
        message = @"播放暂停";
    }
    [self appendLogMessage:message];
}

//

- (void)onSynthesisCompleted {
    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
    [self appendLogMessage:@"开始合成"];
}
/// 合成的第一帧的数据已经得到了
- (void)onPrepared {
//    NSLog(@"拿到第一帧数据");
}
- (void)onBinaryReceivedData:(NSData *)data audioType:(NSString *)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    [self appendLogMessage:[NSString stringWithFormat:@"收到合成回调的数据"]];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    [self appendLogMessage:[NSString stringWithFormat:@"合成失败 %@",failreModel.message]];
}

//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:textViewText]&&textView == self.textView) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    if (self.displayTextView.isFirstResponder) {
        [self.displayTextView resignFirstResponder];
    }
}

//MARK: player Delegate


- (void)readlyToPlay {
    [self appendLogMessage:@"准备就绪"];
    self.playButton.selected = YES;
}

- (void)playFinished {
    [self appendLogMessage:@"播放结束"];
    [self resetPlayState];
    self.playButton.selected = NO;
}

- (void)playPausedIfNeed {
    self.playButton.selected = NO;
    [self appendLogMessage:@"暂停"];

}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
    [self appendLogMessage:@"播放"];
}

- (void)updateBufferPositon:(float)bufferPosition {
    [self appendLogMessage:[NSString stringWithFormat:@"buffer 进度 %.0f%%",bufferPosition*100]];
}
- (void)playerFaiure:(NSString *)errorStr {
    [self appendLogMessage:[NSString stringWithFormat:@"播放器出错:%@",errorStr]];
    
}

// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}




- (NSString *)timeDataWithTimeCount:(CGFloat)timeCount {
    long audioCurrent = ceil(timeCount);
    NSString *str = nil;
    if (audioCurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(audioCurrent/60.f)),lround(floor(audioCurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(audioCurrent/3600.f)),lround(floor(audioCurrent%3600)/60.f),lround(floor(audioCurrent/1.f))%60];
    }
    return str;
    
}

- (void)appendLogMessage:(NSString *)message {
    NSString *text = self.displayTextView.text;
    NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.displayTextView.text = appendText;
    [self.displayTextView scrollRangeToVisible:NSMakeRange(self.displayTextView.text.length, 1)];
}


@end

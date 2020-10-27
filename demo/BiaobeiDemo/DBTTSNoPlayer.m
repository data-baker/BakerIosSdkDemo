//
//  DBTTSNoPlayer.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/10/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "DBTTSNoPlayer.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import "PCMDataPlayer.h"

NSString * text = @"标贝科技交互提供智能语音整体解决方案和数据服务 近期，天津市宝坻区某百货大楼内部，10%的酒精相继出现了5例新型冠状病毒感染的肺炎病例。这几个病例都没有去过武汉，也没有接触过确诊病例，而且从前三个病例发病时的情况看，似乎找不到到任何流行病学上的关联性。他们是怎么发病的？发病前有哪些情况是可以溯源？2月2日，天津市疾控中心传染病预防控制室主任张颖在发布会上，针对这起聚集性暴发的疫情进行了全程脱稿的“福尔摩斯式”分析，谜底层层被揭开，而这背后，给大家的却是一个深刻的警示！ 我们再来复盘一下—— 第1个病例：";// 百货大楼小家电区销售人员无武汉的流行病学史，无外出经历，也没有接触过确诊病例或疑似病例1月22日发热，商场26日春节停业。该售货员发病之后连续4天都在没有发热门诊的社区门诊看病。期间，她持续高热，自己购买药物在家中处理。31日到天津宝坻区医院的发热门诊就诊。最终被天津市疾病预防控制中心确认为确诊病例。源？2月2日，天津市疾控中心传染病预防控制室主任张颖在发布会上，针对这起聚集性暴发的疫情进行了全程脱稿的“福尔摩斯式”分析，谜底层层被揭开，而这背后，给大家的却是一个深刻的警示！ 我们再来复盘一下—— 第1个病例： 百货大楼小家电区销售人员无武汉的流行病学史，无外出经历，也没有接触过确诊病例或疑似病例1月22日发热，商场26日春节停业。该售货员发病之后连续4天都在没有发热门诊的社区门诊看病。期间，她持续高热，自己购买药物在家中处理。31日到天津宝坻区医院的发热门诊就诊。最终被天津市疾病预防控制中心确认为确诊病例。";
@interface DBTTSNoPlayer ()<DBSynthesizerManagerDelegate,UITextViewDelegate>
/// 合成管理类
//@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;

/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;

@property (nonatomic, strong)PCMDataPlayer * player;

@end

@implementation DBTTSNoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"语音合成在线sdk无播放器";
    
    self.textString = [text mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = text;
    
    
//    _synthesizerManager = [DBSynthesizerManager instance];
    //设置打印日志
    _synthesizerManager.log = NO;
    _synthesizerManager.delegate = self;
    //TODO: 如果使用私有化部署,按如下方式设置URL,否则设置setupClientId：clientSecret：的方法进行授权
//   [_synthesizerManager setupPrivateDeploymentURL:@"ws://192.168.1.19:19009"];
    
//    [_synthesizerManager setupClientId:@"e2d17fce-f69a-4b78-bbe5-7fef824a77c2" clientSecret:@"ZTZlOTMyMzAtMThlZS00M2ZjLWJhMTktYTQ2NjBhZTE3Yzk0" handler:^(BOOL ret, NSString *message) {
//        if (ret) {
//            NSLog(@"鉴权成功");
//        }else {
//            NSLog(@"鉴权失败");
//        }
//    }];

    
}

// MARK: IBActions

- (IBAction)startAction:(id)sender {
    // 先清除之前的数据
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
        [self.synthesizerManager start];
    }

}
- (IBAction)closeAction:(id)sender {
    [self.synthesizerManager stop];
    [self.player stopPlay];
    self.player = nil;
    self.displayTextView.text = @"";

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
    [self.player appendData:data endFlag:endFlag];
    
    [self.player startPlay];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    [self appendLogMessage:[NSString stringWithFormat:@"合成失败 %@",failreModel.message]];
}

//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:text]&&textView == self.textView) {
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



// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}


- (void)appendLogMessage:(NSString *)message {
    NSString *text = self.displayTextView.text;
    NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.displayTextView.text = appendText;
    [self.displayTextView scrollRangeToVisible:NSMakeRange(self.displayTextView.text.length, 1)];
}

-(PCMDataPlayer *)player {
    if (!_player) {
        _player = [[PCMDataPlayer alloc]init];
    }
    return _player;
}

@end

//
//  ViewController.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "ViewController.h"
#import "DBAuthorizationVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"标贝demo";
}

- (IBAction)ttsClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBAuthorizationVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBAuthorizationVC"];
    vc.type = DBDemoTypeTTS;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)asrClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBAuthorizationVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBAuthorizationVC"];
    vc.type = DBDemoTypeASR;
    [self.navigationController pushViewController:vc animated:YES];
}





@end

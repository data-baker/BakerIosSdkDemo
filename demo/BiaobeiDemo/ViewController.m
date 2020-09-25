//
//  ViewController.m
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import "ViewController.h"
#import "DBAuthorizationVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"语音合成在线";
            break;
        case 1:
            cell.textLabel.text = @"语音合成离线";
            break;
        case 2:
            cell.textLabel.text = @"语音识别";
            break;
        case 3:
            cell.textLabel.text = @"长语音识别";
            break;
        case 4:
            cell.textLabel.text = @"声音复刻";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DBAuthorizationVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DBAuthorizationVC"];
    if (indexPath.row == 0) {
        vc.type = DBDemoTypeTTS;
    }else {
        vc.type = DBDemoTypeASR;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



@end

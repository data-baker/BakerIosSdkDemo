//
//  DBAuthorizationVC.h
//  BiaobeiDemo
//
//  Created by 李明辉 on 2020/8/19.
//  Copyright © 2020 biaobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DBDemoType){
    DBDemoTypeTTS,
    DBDemoTypeASR,
};

@interface DBAuthorizationVC : UIViewController

@property (nonatomic, assign) DBDemoType type;

@end

NS_ASSUME_NONNULL_END

//
//  LSAppDelegate.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSNavViewController.h"
#import "LSRequestDetailViewController.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property LSNavViewController * navVC;
@property LSRequestDetailViewController * rdVC;

@end

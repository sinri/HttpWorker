//
//  LSDutyTableViewController.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSHttpDuty.h"
#import "LSDutyFiles.h"

@interface LSDutyTableViewController : UITableViewController
<UIAlertViewDelegate>
@property id<LSHttpDutyVCDelegate> delegate;
@end

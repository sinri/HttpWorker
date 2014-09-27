//
//  LSRequestDetailViewController.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSKVPairTableViewCell.h"
#import "LSPostBodyTableViewCell.h"
#import "LSHttpMethodTableViewCell.h"
#import "LSFieldTableViewCell.h"
#import "LSHttpDuty.h"
#import "LSDutyFiles.h"

@interface LSRequestDetailViewController : UITableViewController
<LSRDCellDelegate,LSHttpDutyVCDelegate>
{
    UIActivityIndicatorView * activityIndicatorView;
    UIView * activityIndicatorBackgroundView;
}
@property LSHttpDuty * httpDuty;
@property BOOL hasPostBodyCell;

@end

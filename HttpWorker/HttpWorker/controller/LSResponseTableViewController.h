//
//  LSResponseTableViewController.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-23.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSREKVTableViewCell.h"
#import "LSDataTableViewCell.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface LSResponseTableViewController : UITableViewController
<UIActionSheetDelegate,ADBannerViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSDictionary* response_dict;
    
    ADBannerView * adView;
    GADBannerView *bannerView_;
    BOOL needAdMob;
    
    BOOL isDone;
    //RESPONSE
    NSString * method;
    NSHTTPURLResponse*response;
    NSInteger status_code;
    NSString * desc_status_code;
    NSDictionary * headers;
    //ERROR
    NSDictionary * error_info;
    //DATA
    NSData * data;
    NSStringEncoding currentEncoding;
}
-(id)initWithStyle:(UITableViewStyle)style andResponseDict:(NSDictionary*)dict;

@end

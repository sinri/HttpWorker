//
//  LSRDBaseTableViewCell.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSHttpDuty.h"

#define BASE_SECTION 1000

@protocol LSRDCellDelegate <NSObject>
-(LSHttpDuty*)getHttpDuty;
-(void)updateHttpDuty:(NSInteger)cellId value:(NSString*)value key:(NSString*)key;
-(CGFloat)shouldBeWidth;
@end

@interface LSRDBaseTableViewCell : UITableViewCell
@property CGFloat shouldBeWidth;
-(void)designView:(CGFloat)width;
@property id<LSRDCellDelegate> delegate;
@property NSInteger cellId;
@end

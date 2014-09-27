//
//  LSPostBodyTableViewCell.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRDBaseTableViewCell.h"

@interface LSPostBodyTableViewCell : LSRDBaseTableViewCell
<UITextViewDelegate>
@property UITextView * tv;
-(void)setBody:(NSString*)body;
-(NSString*)getBody;
@end

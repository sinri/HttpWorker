//
//  LSDataTableViewCell.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-23.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDataTableViewCell : UITableViewCell
@property UITextView * tv;
//@property UIWebView * wv;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withShouldBeWidth:(CGFloat)sbWidth;
-(void)setText:(NSString*)str url:(NSURL*)url;
@end

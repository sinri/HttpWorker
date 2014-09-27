//
//  LSDataTableViewCell.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-23.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSDataTableViewCell.h"
//#import <QuartzCore/QuartzCore.h>

@implementation LSDataTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _tv = [[UITextView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, 200))];
        [_tv setEditable:NO];
        [self addSubview:_tv];
        [_tv setBackgroundColor:[UIColor colorWithRed:208/255.0 green:255/255.0 blue:196/255.0 alpha:0.5]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withShouldBeWidth:(CGFloat)sbWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _tv = [[UITextView alloc]initWithFrame:(CGRectMake(0, 0, sbWidth, 200))];
        [_tv setEditable:NO];
        [self addSubview:_tv];
        [_tv setBackgroundColor:[UIColor colorWithRed:208/255.0 green:255/255.0 blue:196/255.0 alpha:0.5]];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setText:(NSString*)str url:(NSURL*)url{
    if(str){
        [_tv setText:str];
        //[_wv loadHTMLString:str baseURL:url];
    }else{
        [_tv setText:@""];
        //[_wv loadHTMLString:@"" baseURL:url];
    }
}

@end

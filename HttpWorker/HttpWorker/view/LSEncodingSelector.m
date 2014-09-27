//
//  LSEncodingSelector.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSEncodingSelector.h"
#import <QuartzCore/QuartzCore.h>
@implementation LSEncodingSelector


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _encodingArray=@[@"ASCII",@"UTF8",@"Unicode",@"JapaneseEUC",@"ShiftJIS",@"GBK",@"BIG5"];
        _btnArray=[[NSMutableArray alloc]init];
        CGFloat btnHeight=frame.size.height/[_encodingArray count];
        for (int i=0; i<[_encodingArray count]; i++) {
            UIButton * btn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
            [btn setFrame:(CGRectMake(0, i*btnHeight, frame.size.width, btnHeight))];
            [btn setTitle:[_encodingArray objectAtIndex:i] forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(onButton:) forControlEvents:(UIControlEventTouchUpInside)];
            //[btn setTitleShadowColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
            //[btn setTitleShadowColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            //[btn setBackgroundImage:[self createImageWithColor:[UIColor redColor]] forState:(UIControlStateHighlighted)];
            //[btn setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:(UIControlStateNormal)];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [self addSubview:btn];
            
            [_btnArray addObject:btn];
        }
    }
    [self updateHLBtn];
    return self;
}
-(void)updateHLBtn{
//    NSLog(@"[LSHttpDuty getCustomEncoding]=%d",[LSHttpDuty getCustomEncoding]);
    for (UIButton * btn in _btnArray) {
//        NSLog(@"btn text is %@=%uld",[[btn titleLabel]text],[LSCharsetWorker getEncoding: [[btn titleLabel]text]]);
        if([LSCharsetWorker getEncoding: [[btn titleLabel]text]]==[LSHttpDuty getCustomEncoding]){
            //[btn setHighlighted:YES];
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
//            NSLog(@"Y");
        }else{
            //[btn setHighlighted:NO];
            [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
//            NSLog(@"N");
        }
    }
    //[self drawRect:self.frame];
}
-(void)onButton:(id)sender{
    UIButton * btn=(UIButton*)sender;
//    NSLog(@"Change Custom Encoding to %uld",[LSCharsetWorker getEncoding: [[btn titleLabel]text]]);
    [LSHttpDuty setCustomEncoding: [LSCharsetWorker getEncoding: [[btn titleLabel]text]]];
    [self updateHLBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark util
//UIColor 转UIImage
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


//UIImage转UIColor
//[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmailBackground.png"]];

@end

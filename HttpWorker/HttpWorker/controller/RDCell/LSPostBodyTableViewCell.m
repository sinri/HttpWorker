//
//  LSPostBodyTableViewCell.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSPostBodyTableViewCell.h"

@implementation LSPostBodyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)designView:(CGFloat)width{
    [super designView:width];
    
    _tv=[[UITextView alloc]initWithFrame:(CGRectMake(0, 0, width, self.frame.size.height))];
    [_tv setDelegate:self];
    [_tv setReturnKeyType:(UIReturnKeyDone)];
    [_tv setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_tv];
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
-(void)setBody:(NSString*)body{
    [_tv setText:body];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if([self delegate])[[self delegate] updateHttpDuty:[self cellId] value:_tv.text key:nil];
}
-(NSString*)getBody{
    return _tv.text;
}
@end

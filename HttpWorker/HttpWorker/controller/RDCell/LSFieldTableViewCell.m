//
//  LSFieldTableViewCell.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-26.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSFieldTableViewCell.h"

@implementation LSFieldTableViewCell

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
    
    _keyTF=[[UITextField alloc]initWithFrame:(CGRectMake(5, 5, 90, self.frame.size.height-10))];
    [self addSubview:_keyTF];
    _valueTF=[[UITextField alloc]initWithFrame:(CGRectMake(100, 5, width-105, self.frame.size.height-10))];
    [self addSubview:_valueTF];
    
    [_keyTF setReturnKeyType:(UIReturnKeyDone)];
    [_valueTF setReturnKeyType:(UIReturnKeyDone)];
    
    [_keyTF setAutocorrectionType:(UITextAutocorrectionTypeNo)];
    [_valueTF setAutocorrectionType:(UITextAutocorrectionTypeNo)];
    
    [_keyTF setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
    [_valueTF setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
    
    [_keyTF setDelegate:self];
    [_valueTF setDelegate:self];
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
-(void)setAsCertainedKey:(NSString*)key value:(NSString*)value{
    [_keyTF setText:key];
    [_valueTF setText:value];
    [_keyTF setBorderStyle:(UITextBorderStyleNone)];
    [_valueTF setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_keyTF setEnabled:NO];
}
//-(void)setAsFreeKey:(NSString*)key value:(NSString*)value{
//    [_keyTF setText:key];
//    [_valueTF setText:value];
//    [_keyTF setBorderStyle:(UITextBorderStyleRoundedRect)];
//    [_valueTF setBorderStyle:(UITextBorderStyleRoundedRect)];
//    [_keyTF setEnabled:YES];
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if([self delegate])[[self delegate] updateHttpDuty:[self cellId] value:_valueTF.text key:_keyTF.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

-(NSString*)getKey{
    return _keyTF.text?_keyTF.text:@"";
}
-(NSString*)getValue{
    return _valueTF.text?_valueTF.text:@"";
}


@end

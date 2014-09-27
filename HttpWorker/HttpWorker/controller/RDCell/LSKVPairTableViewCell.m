//
//  LSKVPairTableViewCell.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSKVPairTableViewCell.h"

@implementation LSKVPairTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"LSKVPairTableViewCell width=%f",self.frame.size.width);
        
        
    }
    return self;
}

-(void)designView:(CGFloat)width{
    [super designView:width];
    
    _keyLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 10, 80, 30))];
    [_keyLabel setText:@"Key:"];
    [self addSubview:_keyLabel];
    
    _valueLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 60, 80, 30))];
    [_valueLabel setText:@"value:"];
    [self addSubview:_valueLabel];
    
    _keyTF=[[UITextField alloc]initWithFrame:(CGRectMake(90, 10, width-100, 30))];
    [self addSubview:_keyTF];
    _valueTF=[[UITextField alloc]initWithFrame:(CGRectMake(90, 60, width-100, self.frame.size.height-10))];
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
-(void)setAsFreeKey:(NSString*)key value:(NSString*)value{
    [_keyTF setText:key];
    [_valueTF setText:value];
    [_keyTF setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_valueTF setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_keyTF setEnabled:YES];
}

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

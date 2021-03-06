//
//  LSKVPairTableViewCell.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRDBaseTableViewCell.h"

@interface LSKVPairTableViewCell : LSRDBaseTableViewCell
<UITextFieldDelegate>
@property UILabel * keyLabel;
@property UILabel * valueLabel;
@property UITextField * keyTF;
@property UITextField * valueTF;

-(void)setAsCertainedKey:(NSString*)key value:(NSString*)value;
-(void)setAsFreeKey:(NSString*)key value:(NSString*)value;

-(NSString*)getKey;
-(NSString*)getValue;

@end

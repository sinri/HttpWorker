//
//  LSSettingViewController.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSEncodingSelector.h"
@interface LSSettingViewController : UIViewController
<UITextFieldDelegate>
@property UILabel * TimeoutLabel;
@property UITextField * TimeoutTF;

@property UILabel * EncodingLabel;
@property LSEncodingSelector * EncodingSelector;
@end

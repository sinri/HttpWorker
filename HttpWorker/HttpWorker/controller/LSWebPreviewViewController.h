//
//  LSWebPreviewViewController.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWebPreviewViewController : UIViewController
<UIWebViewDelegate>
{
    NSString * wv_html;
    NSURL * wv_url;
}
@property UIWebView * wv;
-(id)initWithHTML:(NSString*)html withURL:(NSURL*)url;
@end

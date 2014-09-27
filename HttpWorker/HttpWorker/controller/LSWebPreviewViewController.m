//
//  LSWebPreviewViewController.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSWebPreviewViewController.h"
#import "MobClick.h"

@interface LSWebPreviewViewController ()

@end

@implementation LSWebPreviewViewController

-(id)initWithHTML:(NSString*)html withURL:(NSURL*)url{
    self=[super init];
    if(self){
        wv_html=html;
        wv_url=url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _wv = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_wv setDelegate:self];
    [self.view addSubview:_wv];
    [_wv loadHTMLString:wv_html baseURL:wv_url];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LSWebPreviewViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LSWebPreviewViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString*title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(title && ![title isEqualToString:@""]){
        self.navigationItem.title=title;
    }else{
        self.navigationItem.title=@"Preview";
    }
    //self.navigationItem.title = [NSString stringWithFormat:@"Preview %@",title];
}

@end

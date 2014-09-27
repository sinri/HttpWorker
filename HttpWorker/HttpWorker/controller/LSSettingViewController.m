//
//  LSSettingViewController.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSSettingViewController.h"
#import "LSHttpDuty.h"
#import "MobClick.h"

@interface LSSettingViewController ()

@end

@implementation LSSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Settings"];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:235.0/255 green:235.0/255 blue:242.0/255 alpha:1];
    
    self.TimeoutLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 80, self.view.frame.size.width/2-20, 30))];
    [self.TimeoutLabel setText:@"Timeout (second)"];
    [self.TimeoutLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.TimeoutLabel];
    
    self.TimeoutTF=[[UITextField alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2-10, 30))];
    [self.TimeoutTF setText:[NSString stringWithFormat:@"%d",(NSInteger)[LSHttpDuty getCustomTimeout]]];
    [self.TimeoutTF setTextAlignment:(NSTextAlignmentCenter)];
    [self.TimeoutTF setDelegate:self];
    [self.TimeoutTF setBorderStyle:(UITextBorderStyleRoundedRect)];
    [self.view addSubview:self.TimeoutTF];
    
    self.EncodingLabel=[[UILabel alloc]initWithFrame:(CGRectMake(10, 140, self.view.frame.size.width-20, 30))];
    [self.EncodingLabel setText:@"Default Encoding to parse response"];
    [self.EncodingLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.EncodingLabel];
    
    self.EncodingSelector = [[LSEncodingSelector alloc]initWithFrame:(CGRectMake(10, 190, self.view.frame.size.width-20, 250))];
    [self.view addSubview:self.EncodingSelector];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LSSettingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LSSettingViewController"];
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

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [LSHttpDuty setCustomTimeout:[self.TimeoutTF.text doubleValue]];
    [self.TimeoutTF setText:[NSString stringWithFormat:@"%d",(NSInteger)[LSHttpDuty getCustomTimeout]]];
}


@end

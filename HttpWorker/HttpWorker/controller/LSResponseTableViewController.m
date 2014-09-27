//
//  LSResponseTableViewController.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-23.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSResponseTableViewController.h"
#import "LSWebPreviewViewController.h"
#import "LSCharsetWorker.h"
#import "LSHttpDuty.h"
#import "MobClick.h"


@interface LSResponseTableViewController ()

@end

@implementation LSResponseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        response_dict=@{@"submit": @NO,@"data":@"Please submit again!"};
    }
    return self;
}
-(id)initWithStyle:(UITableViewStyle)style andResponseDict:(NSDictionary*)dict{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        response_dict=dict;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    needAdMob=NO;
    
    self.navigationItem.title=@"Response";
    
    UIBarButtonItem * sendBtn=[[UIBarButtonItem alloc]initWithTitle:@"Report" style:(UIBarButtonItemStylePlain) target:self action:@selector(onSendBtn:)];
    self.navigationItem.rightBarButtonItem=sendBtn;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    currentEncoding=[LSHttpDuty getCustomEncoding];
    isDone=NO;
    headers=@{};
    error_info=@{};
    data=nil;
    if(response_dict && [[response_dict objectForKey:@"submit"]boolValue]){
        response=[response_dict objectForKey:@"response"];
        if(response && ![response isEqual:[NSNull null]]){
            isDone=YES;
            status_code=[response statusCode];
            desc_status_code=[NSHTTPURLResponse localizedStringForStatusCode:status_code];
            headers=[response allHeaderFields];
        }
        method=[response_dict objectForKey:@"method"];
        NSError * error=[response_dict objectForKey:@"error"];
        if(error && ![error isEqual:[NSNull null]]){
            NSString*desc=[error localizedDescription];
            desc=desc?desc:@"NONE";
            NSString*reason=[error localizedFailureReason];
            reason=reason?reason:@"NONE";
            error_info=@{@"Description": desc,@"Reason":reason};
        }
        data=[response_dict objectForKey:@"data"];
        if([data isEqual:[NSNull null]]){
            data=nil;
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"EXCEPTION" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LSResponseTableViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LSResponseTableViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger c=0;
    switch (section) {
        case 0:
            c=[headers count]+1;
            break;
        case 1:
            c=[error_info count];
            break;
        case 2:
            c=1;
        default:
            break;
    }
    return c;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseId=@"";
    if(indexPath.section<2){
        reuseId=@"response_fields_cell";
    }else if(indexPath.section==2){
        reuseId=@"response_data_cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell){
        if(indexPath.section<2){
            cell = [[LSREKVTableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:reuseId];
        }else if(indexPath.section==2){
            cell = [[LSDataTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId withShouldBeWidth:self.tableView.frame.size.width];
        }
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row==0){
                [[cell textLabel]setText:@"TARGET URL"];
                if(response){
                    [[cell detailTextLabel]setText:[[response URL]absoluteString]];
                }else{
                    [[cell detailTextLabel]setText:@"No URL"];
                }
            }else{
                NSString*key=[[headers allKeys] objectAtIndex:indexPath.row-1];
                NSString*value=[headers objectForKey:key];
                [[cell textLabel]setText:key];
                [[cell detailTextLabel]setText:value];
            }
        }
            break;
        case 1:
        {
            NSString*key=[[error_info allKeys] objectAtIndex:indexPath.row];
            NSString*value=[error_info objectForKey:key];
            [[cell textLabel]setText:key];
            [[cell detailTextLabel]setText:value];
            //            [[cell detailTextLabel] setNumberOfLines:0];
            //            [[cell detailTextLabel] setLineBreakMode:(NSLineBreakByWordWrapping)];
        }
            break;
        case 2:
        {
            //[((LSDataTableViewCell*)cell) setData:data];
            //[LSCharsetWorker dataToString:data usingEncoding:@"ASCII"]
            NSString * text=[[NSString alloc]initWithData:data encoding:currentEncoding];
            [((LSDataTableViewCell*)cell) setText:text url:response.URL];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.tableView.frame.size.width, 50))];
    UILabel * label=[[UILabel alloc]initWithFrame:(CGRectMake(5, 10, self.tableView.frame.size.width-10, 30))];
    [header addSubview:label];
    switch (section) {
        case 0:
            [label setText: [NSString stringWithFormat:@"Code %d:%@",status_code,(desc_status_code?desc_status_code:@"ERROR")]];
            break;
        case 1:
            if(error_info && [error_info count]>0){
                [label setText: @"ERROR"];
            }else{
                [label setText:  @"NO ERROR"];
            }
            break;
        case 2:
            if (data) {
                [label setText:  @"DATA"];
                [label setFrame:CGRectMake(5, 10, 90, 30)];
                UIButton * previewBtn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
                [previewBtn setFrame:(CGRectMake(100, 10, self.tableView.frame.size.width-210, 30))];
                [previewBtn setTitle:@"Preview" forState:(UIControlStateNormal)];
                [previewBtn setTitleColor: [UIColor blueColor] forState:(UIControlStateNormal)];
                [previewBtn addTarget:self action:@selector(onPreviewBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                [header addSubview:previewBtn];
                
                UIButton * charsetBtn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
                [charsetBtn setFrame:(CGRectMake(self.tableView.frame.size.width-90, 10, 80, 30))];
                [charsetBtn setTitle:@"Encoding" forState:(UIControlStateNormal)];
                [charsetBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
                [charsetBtn addTarget:self action:@selector(onEncodingBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                [header addSubview:charsetBtn];
            }else{
                [label setText:  @"NO DATA"];
            }
            break;
        default:
            [label setText:  @"..."];
            break;
    }
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2 && data) {
        return 200;
    }else if(indexPath.section==1){
        return 80;
    }else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==1){
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
            return 110;
        }else{
            return 60;
        }
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section!=1){
        UIView * view=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.tableView.frame.size.width, 5))];
        return view;
    }else{
#warning TODO AD
//        if(!adView){
//            adView = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width, 50)];
//            //adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//            //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//            
//            adView.delegate = self;
//        }else{
//            [adView removeFromSuperview];
//        }
        UIView * view=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.tableView.frame.size.width, 60))];
//        [view addSubview:adView];
        UIView* adview=[self runAD];
        [view addSubview:adview];
        
        return view;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark encoding
-(void)onPreviewBtn:(id)sender{
    NSString * text=[[NSString alloc]initWithData:data encoding:currentEncoding];
    LSWebPreviewViewController * wpvc=[[LSWebPreviewViewController alloc]initWithHTML:text withURL:response.URL];
    [self.navigationController pushViewController:wpvc animated:YES];
}
-(void)onEncodingBtn:(id)sender{
    UIButton * btn=(UIButton*)sender;
    UIActionSheet * as = [[UIActionSheet alloc]initWithTitle:@"Select Encoding" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Basic ASCII" otherButtonTitles:@"UTF8",@"Unicode",@"JapaneseEUC",@"ShiftJIS",@"GBK",@"BIG5", nil];
    //[as showFromRect:btn.frame inView:self.view animated:YES];
    [as showInView:self.view];
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
//            NSLog(@"0 ASCII");
            currentEncoding=[LSCharsetWorker getEncoding:@"ASCII"];
            break;
        case 1:
//            NSLog(@"1 UTF8");
            currentEncoding=[LSCharsetWorker getEncoding:@"UTF8"];
            break;
        case 2:
//            NSLog(@"2 Unicode");
            currentEncoding=[LSCharsetWorker getEncoding:@"Unicode"];
            break;
        case 3:
//            NSLog(@"3 JapaneseEUC");
            currentEncoding=[LSCharsetWorker getEncoding:@"JapaneseEUC"];
            break;
        case 4:
//            NSLog(@"4 ShiftJIS");
            currentEncoding=[LSCharsetWorker getEncoding:@"ShiftJIS"];
            break;
        case 5:
//            NSLog(@"5 GBK");
            currentEncoding=[LSCharsetWorker getEncoding:@"GBK"];
            break;
        case 6:
//            NSLog(@"6 BIG5");
            currentEncoding=[LSCharsetWorker getEncoding:@"BIG5"];
            break;
        case 7:
//            NSLog(@"7 CANCEL");
            currentEncoding=[LSCharsetWorker getEncoding:@"CANCEL"];
            break;
            
        default:
            return;
            break;
    }
    [self.tableView reloadData];
    
}



#pragma mark - 在应用内发送邮件

-(void)onSendBtn:(id)sender{
    [self sendMailInApp];
}

-(void)alertWithMessage:(NSString*)alert{
    [[[UIAlertView alloc]initWithTitle:nil message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"Mail Function Unavailable in this iOS Veriosn"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"There is not any EMail Account set."];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: [NSString stringWithFormat:@"Response of %@ from %@ - %@ [From HttpWorker]",method,response.URL.absoluteString,[NSDate date]]];
    //添加收件人
    NSArray *toRecipients = @[];//[NSArray arrayWithObject: @"first@example.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = @[];//[NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = @[];//[NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    //UIImage *addPic = _resultImage;//[UIImage imageNamed: @"Icon@2x.png"];
    //NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    //[mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"result.png"];
    
    //添加一个pdf附件
    //NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //NSData *pdf = [NSData dataWithContentsOfFile:file];
    //[mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = [NSString stringWithFormat:@"<h1>HttpWorker Response Report</h1><p>Method: %@</p><p>URL: %@</p><p>Date: %@</p>",method,response.URL.absoluteString,[NSDate date]];
    
    //add details for body
    emailBody = [emailBody stringByAppendingString:@"<hr><h2>Response</h2>"];
    if(response){
        emailBody = [emailBody stringByAppendingFormat:@"<h3>Code: %d</h3><p>%@</p>",status_code,desc_status_code];
        if([headers count]>0){
            emailBody = [emailBody stringByAppendingString:@"<h3>Headers</h3>"];
            for (NSString * key in headers) {
                emailBody = [emailBody stringByAppendingFormat:@"<p>%@: %@</p>",key,[headers objectForKey:key]];
            }
        }
    }else{
        emailBody = [emailBody stringByAppendingString:@"<p>Did not receive response from server.</p>"];
    }
    if(error_info && [error_info count]>0){
        NSString* d=[error_info objectForKey:@"Description"];
        NSString* r=[error_info objectForKey:@"Reason"];
        emailBody = [emailBody stringByAppendingFormat:@"<hr><h2>Error Information</h2>\
                     <h3>Description</h3><p>%@</p>\
                     <h3>Reason</h3><p>%@</p>",
                     d?d:@"None",
                     r?r:@"None"
                     ];
    }
    if(data){
        emailBody = [emailBody stringByAppendingFormat:@"<hr><h2>Response Body</h2><p>%@</p>",
                     [[NSString alloc] initWithData:data encoding:currentEncoding]
                     ];
    }
    emailBody = [emailBody stringByAppendingString:@"<hr><p>Provided by HttpWorker on iOS, Copyright 2014 Lijun Ni</p><p><a href='http://github.everstray.com/'>Visit Homepage</a></p><hr>"];
    
    [mailPicker setMessageBody:emailBody isHTML:YES];
    //[self presentModalViewController: mailPicker animated:YES];
    [self.navigationController presentViewController:mailPicker animated:YES completion:^{
        //
    }];
    //[mailPicker release];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    //[self dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:^{
        //
    }];
    if(result==MFMailComposeResultSent){
        NSDictionary *dict = @{@"code":[NSNumber numberWithInt: status_code]};
        [MobClick event:@"DUTY_MAILED" attributes:dict];
    }
    if(NO){
        NSString *msg;
        switch (result) {
            case MFMailComposeResultCancelled:
                msg = @"Cancelled";//NSLocalizedString(@"キャンセルしてしまいました。",nil);
                break;
            case MFMailComposeResultSaved:
                msg = @"Saved";//NSLocalizedString(@"保存してしまいました。",nil);
                break;
            case MFMailComposeResultSent:
                msg = @"Preparing to send";//NSLocalizedString(@"すでに発信準備中です。",nil);
                break;
            case MFMailComposeResultFailed:
                msg = @"Failed";//NSLocalizedString(@"保存または発信が失敗してしまいました。",nil);
                break;
            default:
                msg = @"Thanks anyway...";//NSLocalizedString(@"ご利用ありがとうございました。",nil);
                break;
        }
        [self alertWithMessage:msg];
    }
}

#pragma mark ADMOB
#pragma mark iad
- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"bannerViewWillLoadAd");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError");
    needAdMob=YES;
    [self performSelector:@selector(runAdMob) withObject:nil afterDelay:0.1];
}
-(void)runAdMob{
    [adView removeFromSuperview];
    
    // 在屏幕顶部创建标准尺寸的视图。
    // 在GADAdSize.h中对可用的AdSize常量进行说明。
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // 指定广告单元ID。
    bannerView_.adUnitID = @"ca-app-pub-5323203756742073/4952647944";
    
    // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个UIViewController
    // 并将其添加至视图层级结构。
    bannerView_.rootViewController = self;
    //[self.view addSubview:bannerView_];
    
    // 启动一般性请求并在其中加载广告。
    [bannerView_ loadRequest:[GADRequest request]];
}
-(UIView*)runAD{
    if(!needAdMob){
        if(!adView){
            adView = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width, 50)];
            adView.delegate = self;
        }
        return adView;
    }else{
        if(!bannerView_){
            [self runAdMob];
        }
        return bannerView_;
    }
}
@end

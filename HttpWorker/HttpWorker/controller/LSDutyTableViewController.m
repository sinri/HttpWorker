//
//  LSDutyTableViewController.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-25.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSDutyTableViewController.h"
#import "MobClick.h"

@interface LSDutyTableViewController ()

@end

@implementation LSDutyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Duties";
    
    UIBarButtonItem * help=[[UIBarButtonItem alloc]initWithTitle:@"Online Tool" style:(UIBarButtonItemStylePlain) target:self action:@selector(onHelp:)];
    self.navigationItem.rightBarButtonItem=help;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LSDutyTableViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LSDutyTableViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onHelp:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.everstray.com/HttpWorker/"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LSDutyFiles getDutyFileArray]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSDutyCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LSDutyCell"];
    }
    
    // Configure the cell...
    NSString * path=[[LSDutyFiles getDutyFileArray] objectAtIndex:indexPath.row];
    NSString * fn=[[path lastPathComponent]stringByDeletingPathExtension];
    [[cell textLabel]setText:fn];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString * fn = [[LSDutyFiles getDutyFileArray]objectAtIndex:indexPath.row];
        NSError * error=nil;
        BOOL deleted=[[NSFileManager defaultManager]removeItemAtPath:fn error:&error];
        if(deleted){
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * fn = [[LSDutyFiles getDutyFileArray]objectAtIndex:indexPath.row];
    NSString * msg=@"- -";
    NSError*error=nil;
    NSData*data=[NSData dataWithContentsOfFile:fn options:NSDataReadingMappedIfSafe error:&error];
    if(data){
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        if(dict){
            LSHttpDuty * httpDuty=[LSHttpDuty httpDutyFromJSONDict:dict];
            if(httpDuty && _delegate){
                [_delegate refreshHttpDuty:httpDuty];
                NSDictionary *dict = @{@"url" : httpDuty.URL};
                [MobClick event:@"DUTY_LOAD" attributes:dict];
                msg=nil;
            }else{
                msg=@"Duty file contains error, cannot phrase it to duty!";
            }
        }else{
            msg=@"Duty file is not in standard format!";
        }
    }else{
        msg=[NSString stringWithFormat:@"Cannot fetch data from target file with reason:%@",[error localizedFailureReason]];
    }
    if(msg){
        [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"Duty loaded.\nClick Back to go back to duty view." delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Back", nil]show];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

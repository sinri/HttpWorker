//
//  LSRequestDetailViewController.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSRequestDetailViewController.h"
#import "LSResponseTableViewController.h"
#import "LSSettingViewController.h"
#import "LSDutyTableViewController.h"
#import "MobClick.h"

#import <QuartzCore/QuartzCore.h>

@interface LSRequestDetailViewController ()

@end

@implementation LSRequestDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _httpDuty=[[LSHttpDuty alloc]init];
        _hasPostBodyCell=NO;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Http Worker";
    
    UIBarButtonItem * settingBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings"] style:(UIBarButtonItemStylePlain) target:self action:@selector(onSettingBtn:)];
    [self.navigationItem setLeftBarButtonItem:settingBtn];
    
    UIBarButtonItem * dutyBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemBookmarks) target:self action:@selector(onDutyBtn:)];
    //[[UIBarButtonItem alloc]initWithTitle:@"Duties" style:(UIBarButtonItemStylePlain) target:self action:@selector(onDutyBtn:)];
    [self.navigationItem setRightBarButtonItem:dutyBtn];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LSRequestDetailViewController"];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LSRequestDetailViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(LSHttpDuty*)getHttpDuty{
    return _httpDuty;
}

-(void)onSettingBtn:(id)sender{
    LSSettingViewController * setvc=[[LSSettingViewController alloc]init];
    UIBarButtonItem *NextBackBtn =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:NextBackBtn];
    [self.navigationController pushViewController:setvc animated:YES];
}
-(void)onDutyBtn:(id)sender{
    LSDutyTableViewController * dutyVC=[[LSDutyTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    [dutyVC setDelegate:self];
    UIBarButtonItem *NextBackBtn =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:NextBackBtn];
    [self.navigationController pushViewController:dutyVC animated:YES];
}
-(void)onAddHeader:(id)sender{
    NSString * temp=[NSString stringWithFormat:@"Header%d", _httpDuty.headerArray.count+1];
    [_httpDuty addHeader:temp value:@""];
//    NSIndexPath *newIP=[NSIndexPath indexPathForRow:_httpDuty.headerArray.count-1 inSection:1];
//    NSIndexPath *newIP2=[NSIndexPath indexPathForRow:_httpDuty.headerArray.count inSection:1];
//    [self.tableView insertRowsAtIndexPaths:@[newIP,newIP2] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    NSIndexPath *newIP=[NSIndexPath indexPathForRow:_httpDuty.headerArray.count-1 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[newIP] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    [self.tableView reloadData];
}
-(void)onAddParameter:(id)sender{
    NSString * temp=[NSString stringWithFormat:@"Param%d", _httpDuty.parameterArray.count+1];
    [_httpDuty addParameter:temp value:@""];
//    NSIndexPath *newIP=[NSIndexPath indexPathForRow:_httpDuty.parameterArray.count-1 inSection:2];
//    NSIndexPath *newIP2=[NSIndexPath indexPathForRow:_httpDuty.parameterArray.count inSection:2];
//    [self.tableView insertRowsAtIndexPaths:@[newIP,newIP2] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    NSIndexPath *newIP=[NSIndexPath indexPathForRow:_httpDuty.parameterArray.count-1 inSection:2];
    [self.tableView insertRowsAtIndexPaths:@[newIP] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    [self.tableView reloadData];
}
-(void)onAddPostBody:(id)sender{
    if(!_hasPostBodyCell){
        _hasPostBodyCell=YES;
        NSIndexPath *newIP=[NSIndexPath indexPathForRow:0 inSection:3];
        [self.tableView insertRowsAtIndexPaths:@[newIP] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        
        [(UIButton*)sender setTitle:@"Delete" forState:(UIControlStateNormal)];
    }else{
        _hasPostBodyCell=NO;
        NSIndexPath *newIP=[NSIndexPath indexPathForRow:0 inSection:3];
        [self.tableView deleteRowsAtIndexPaths:@[newIP] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [(UIButton*)sender setTitle:@"Add" forState:(UIControlStateNormal)];
    }
}
-(void)updateHttpDuty:(NSInteger)cellId value:(NSString*)value key:(NSString*)key{
    NSInteger section=cellId/BASE_SECTION;
    NSInteger row=cellId%BASE_SECTION;
//    NSLog(@"updateHttpDuty[%d-%d] key=%@ value=%@",section,row, key,value);
    switch (section) {
        case 0:
            //COMMON
            switch (row) {
                case 0:
                    [_httpDuty setDutyName:value];
                    break;
                case 1:
                    [_httpDuty setURL:value];
                    break;
                case 2:
                    [_httpDuty setUsername:value];
                    break;
                case 3:
                    [_httpDuty setPassword:value];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            //HEADER
//            if(row%2==0){
//                //is key
//                [_httpDuty updateHeader:nil forFieldName:value at:row/2];
//            }else{
//                //is value
//                [_httpDuty updateHeader:value forFieldName:nil at:row/2];
//            }
            [_httpDuty updateHeader:value forFieldName:key at:row];
            break;
        case 2:
            //PARAMETER
//            if(row%2==0){
//                //is key
//                [_httpDuty updateParameter:nil forName:value at:row/2];
//            }else{
//                //is value
//                [_httpDuty updateParameter:value forName:nil at:row/2];
//            }
            [_httpDuty updateParameter:value forName:key at:row];
            break;
        case 3:
            //POSTBODY
            [_httpDuty setPostBody:value];
            break;
            
        default:
            break;
    }
}
//-(void)updateHttpDuty{
//    //COMMON
//    _httpDuty.dutyName=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) getValue];
//    _httpDuty.URL=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) getValue];
//    _httpDuty.username=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]) getValue];
//    _httpDuty.password=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]) getValue];
//    //HEADERS
//    NSInteger header_count=[self.tableView numberOfRowsInSection:1];
//    NSLog(@"header counts %d",header_count);
//    for (int i=0; i<header_count; i++) {
//        NSString * v=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]]) getValue];
//        NSString * k=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]]) getKey];
//        [_httpDuty updateHeader:v forFieldName:k at:i];
//    }
//    //PARAMETERS
//    NSInteger parameter_count=[self.tableView numberOfRowsInSection:2];
//    NSLog(@"parameter counts %d",parameter_count);
//    for (int i=0; i<parameter_count; i++) {
//        NSString * v=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]]) getValue];
//        NSString * k=[((LSKVPairTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]]) getKey];
//        [_httpDuty updateParameter:v forName:k at:i];
//    }
//    //POST BODY
//    if(_hasPostBodyCell && [self.tableView numberOfRowsInSection:3]>0){
//        NSString * v=[((LSPostBodyTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]) getBody];
//        [_httpDuty setPostBody:v];
//    }
//    NSLog(@"updateHttpDuty done with...");
//    [_httpDuty toJSON];
//}
-(void)doGET{
    [self beginWaiting];
    [self performSelector:@selector(processSubmit:) withObject:@"GET" afterDelay:0.1];
    
}
-(void)doPOST{
    [self beginWaiting];
    [self performSelector:@selector(processSubmit:) withObject:@"POST" afterDelay:0.1];
}

-(void)processSubmit:(NSString*)method{
    //[self updateHttpDuty];
    NSDictionary* dict=[_httpDuty submitWithMethod:method withTimeout:30];
    [self performSelector:@selector(stopWaiting) withObject:nil afterDelay:0.1];
    if(!dict){
        [[[UIAlertView alloc]initWithTitle:nil message:@"ERROR" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }else{
        if(![[dict objectForKey:@"submit"] boolValue]){
            NSString*detail=[dict objectForKey:@"data"];
            [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Failed. Reason: %@",detail] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        }else{
            LSResponseTableViewController * rtvc=[[LSResponseTableViewController alloc]initWithStyle:(UITableViewStyleGrouped) andResponseDict:dict];
            UIBarButtonItem *NextBackBtn =
            [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [[self navigationItem] setBackBarButtonItem:NextBackBtn];
            [self.navigationController pushViewController:rtvc animated:YES];
        }
    }
}

-(void)doSAVE{
    if([_httpDuty dutyName] && ![[_httpDuty dutyName] isEqualToString:@""]){
        BOOL done=[LSDutyFiles saveDuty:_httpDuty];
        NSString * msg=done?@"Your duty has been saved.":@"Failed to save your duty.";
        [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        NSDictionary *dict = @{@"url" : _httpDuty.URL};
        [MobClick event:@"DUTY_SAVE" attributes:dict];
    }else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"Please give the duty name!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

-(void)beginWaiting{
    if(activityIndicatorView){
        [activityIndicatorView removeFromSuperview];
    }
    if(activityIndicatorBackgroundView){
        [activityIndicatorBackgroundView removeFromSuperview];
    }
    CGFloat boardSize=60;
    activityIndicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    activityIndicatorBackgroundView=[[UIView alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/2-boardSize/2, self.view.frame.size.height/2-boardSize/2, boardSize, boardSize))];
    [activityIndicatorBackgroundView setBackgroundColor:[UIColor blackColor]];
    activityIndicatorBackgroundView.layer.cornerRadius=5;
    activityIndicatorBackgroundView.layer.masksToBounds=YES;
    
    [activityIndicatorBackgroundView addSubview:activityIndicatorView];
    [self.view.window addSubview:activityIndicatorBackgroundView];
    
    [activityIndicatorView setCenter:(CGPointMake(boardSize/2, boardSize/2))];
    
    [activityIndicatorView startAnimating];
    
}
-(void)stopWaiting{
    if(activityIndicatorView){
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    }
    if(activityIndicatorBackgroundView){
        [activityIndicatorBackgroundView removeFromSuperview];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows=0;
    switch (section) {
        case 0:
            rows=4;
            break;
        case 1:
            rows=_httpDuty.headerArray.count;
            break;
        case 2:
            rows=_httpDuty.parameterArray.count;
            break;
        case 3:
            rows=_hasPostBodyCell?1:0;
            break;
        case 4:
            rows=3;
            break;
        default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseId=@"FieldCellReuseID";
    if(indexPath.section==1||indexPath.section==2){
        reuseId=@"KVPairCellReuseID";
    }else    if(indexPath.section==3){
        reuseId=@"PostBodyCellReuseID";
    }else if(indexPath.section==4){
        reuseId=@"MethodCellReuseID";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    //[((LSRDBaseTableViewCell*)cell) designView:self.tableView.frame.size.width];
    if(!cell){
        if(indexPath.section==3){
            cell=[[LSPostBodyTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId];
            [((LSPostBodyTableViewCell*)cell) designView:self.tableView.frame.size.width];
        }else if(indexPath.section==4){
            cell=[[LSHttpMethodTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId];
            [((LSHttpMethodTableViewCell*)cell) designView:self.tableView.frame.size.width];
        }else if(indexPath.section==1 || indexPath.section==2){
            cell=[[LSKVPairTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId];
            [((LSKVPairTableViewCell*)cell) designView:self.tableView.frame.size.width];
        } else{
            cell=[[LSFieldTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId];
            [((LSFieldTableViewCell*)cell) designView:self.tableView.frame.size.width];
        }
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [((LSRDBaseTableViewCell*)cell) setDelegate:self];
    }
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
                [((LSFieldTableViewCell *)cell) setAsCertainedKey:@"Duty Name" value:_httpDuty.dutyName];
                break;
            case 1:
                [((LSFieldTableViewCell *)cell) setAsCertainedKey:@"URL" value:_httpDuty.URL];
                break;
            case 2:
                [((LSFieldTableViewCell *)cell) setAsCertainedKey:@"Username" value:_httpDuty.username];
                break;
            case 3:
                [((LSFieldTableViewCell *)cell) setAsCertainedKey:@"Password" value:_httpDuty.password];
                break;
            default:
                break;
        }
    }else if(indexPath.section==1){
//        NSInteger index=indexPath.row/2;
//        LSHttpDutyKeyValuePair * pair=[_httpDuty.headerArray objectAtIndex:index];
//        id key = [pair key];
//        id value=[pair value];
//        if(indexPath.row%2==0){
//            [((LSKVPairTableViewCell *)cell) setAsCertainedKey:@"Field" value:key];
//        }else{
//            [((LSKVPairTableViewCell *)cell) setAsCertainedKey:@"Value" value:value];
//        }
        LSHttpDutyKeyValuePair * pair=[_httpDuty.headerArray objectAtIndex:indexPath.row];
        id key = [pair key];
        id value=[pair value];
        [((LSKVPairTableViewCell *)cell) setAsFreeKey:key value:value];
    }else if(indexPath.section==2){
//        NSInteger index=indexPath.row/2;
//        LSHttpDutyKeyValuePair * pair=[_httpDuty.parameterArray objectAtIndex:index];
//        id key = [pair key];
//        id value=[pair value];
//        if(indexPath.row%2==0){
//            [((LSKVPairTableViewCell *)cell) setAsCertainedKey:@"Name" value:key];
//        }else{
//            [((LSKVPairTableViewCell *)cell) setAsCertainedKey:@"Value" value:value];
//        }
        LSHttpDutyKeyValuePair * pair=[_httpDuty.parameterArray objectAtIndex:indexPath.row];
        id key = [pair key];
        id value=[pair value];
        [((LSKVPairTableViewCell *)cell) setAsFreeKey:key value:value];
    }else if(indexPath.section==3){
        [((LSPostBodyTableViewCell*)cell) setBody:[_httpDuty postBody]];
    }else if(indexPath.section==4){
        switch (indexPath.row) {
            case 0:
                [[cell textLabel] setText:@"Submit use GET method"];
                //[[cell detailTextLabel]setText:@"Begin GET http request..."];
                break;
            case 1:
                [[cell textLabel] setText:@"Submit use POST method"];
                //[[cell detailTextLabel]setText:@"Begin POST http request..."];
                break;
            case 2:
                [[cell textLabel] setText:@"Save or Update"];
                break;
            default:
                break;
        }
        [[cell textLabel]setTextAlignment:(NSTextAlignmentCenter)];
    }
    
    [((LSRDBaseTableViewCell *)cell) setCellId:indexPath.section*BASE_SECTION+indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3 || indexPath.section==1 || indexPath.section==2){
        return 100;
    }else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.tableView.frame.size.width, 50))];
    UILabel * title=[[UILabel alloc]initWithFrame:(CGRectMake(5, 5, (self.tableView.frame.size.width-20)/2, 40))];
    [header addSubview:title];
    UIButton * addBtn=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [addBtn setFrame:(CGRectMake(self.tableView.frame.size.width-85, 5, 80, 40))];
    //    [addBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [addBtn setTitle:@"Add" forState:(UIControlStateNormal)];
    switch (section) {
        case 0:
            [title setText:@"Target"];
            break;
        case 1:
            [title setText:@"Headers"];
            [header addSubview:addBtn];
            [addBtn addTarget:self action:@selector(onAddHeader:) forControlEvents:(UIControlEventTouchUpInside)];
            break;
        case 2:
            [title setText:@"Parameters"];
            [header addSubview:addBtn];
            [addBtn addTarget:self action:@selector(onAddParameter:) forControlEvents:(UIControlEventTouchUpInside)];
            break;
        case 3:
            [title setText:@"Post Body"];
            [header addSubview:addBtn];
            [addBtn addTarget:self action:@selector(onAddPostBody:) forControlEvents:(UIControlEventTouchUpInside)];
            break;
        case 4:
            [title setText:@"Method"];
            break;
            
        default:
            break;
    }
    return header;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section==0 || indexPath.section==3 || indexPath.section==4){
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        if(indexPath.section==1){
//            NSInteger row=indexPath.row;
//            NSIndexPath * anotherIP;
//            if(row%2==0){
//                anotherIP=[NSIndexPath indexPathForRow:row+1 inSection:indexPath.section];
//            }else{
//                anotherIP=[NSIndexPath indexPathForRow:row-1 inSection:indexPath.section];
//            }
//            [_httpDuty.headerArray removeObjectAtIndex:indexPath.row/2];
//            [tableView deleteRowsAtIndexPaths:@[indexPath,anotherIP] withRowAnimation:UITableViewRowAnimationNone];
//        }else if(indexPath.section==2){
//            NSInteger row=indexPath.row;
//            NSIndexPath * anotherIP;
//            if(row%2==0){
//                anotherIP=[NSIndexPath indexPathForRow:row+1 inSection:indexPath.section];
//            }else{
//                anotherIP=[NSIndexPath indexPathForRow:row-1 inSection:indexPath.section];
//            }
//            [_httpDuty.parameterArray removeObjectAtIndex:indexPath.row/2];
//            [tableView deleteRowsAtIndexPaths:@[indexPath,anotherIP] withRowAnimation:UITableViewRowAnimationNone];
//        }else{
//            return;
//        }
        if(indexPath.section == 1){
            [_httpDuty.headerArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(indexPath.section==2){
            [_httpDuty.parameterArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    //    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    //        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //    }
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
    [self.view endEditing:YES];
    if(indexPath.section!=4){
        //nothing
    }else{
        if(indexPath.row==0){
            //GET
//            NSLog(@"GET");
            [self performSelector:@selector(doGET) withObject:nil afterDelay:0.1];
        }else if(indexPath.row==1){
            //POST
//            NSLog(@"POST");
            [self performSelector:@selector(doPOST) withObject:nil afterDelay:0.1];
        }else if(indexPath.row==2){
            //SAVE
//            NSLog(@"SAVE");
            [self performSelector:@selector(doSAVE) withObject:nil afterDelay:0.1];
        }
    }
    //[self tableView:tableView didDeselectRowAtIndexPath:indexPath];
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
#pragma mark LSHttpDutyDelegate
-(void)refreshHttpDuty:(LSHttpDuty *)httpDuty{
    _httpDuty=httpDuty;
}
-(CGFloat)shouldBeWidth{
    return self.tableView.frame.size.width;
}
@end

//
//  LSHttpDuty.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSHttpDuty.h"
#import "MobClick.h"

@implementation LSHttpDutyKeyValuePair
-(id)init{
    self=[super init];
    if(self){
        _key=@"";
        _value=@"";
    }
    return self;
}
//
//-(id)getKey{
//    return [super objectForKey:@"key"];
//}
//-(id)getValue{
//    return [super objectForKey:@"value"];
//}
//-(void)setKey:(NSString*)v{
//    [super setObject:v forKey:@"key"];
//}
//-(void)setValue:(NSString*)v{
//    [super setObject:v forKey:@"value"];
//}
-(NSDictionary*)intoDictionary{
//    NSLog(@"LSHttpDutyKeyValuePair intoDictionary key=%@ value=%@",_key,_value);
    if(!_key)_key=@"";
    if(!_value)_value=@"";
    return @{@"key":_key,@"value":_value};
}
@end

static NSTimeInterval custom_timeout=30;
static NSStringEncoding custom_encoding=NSUTF8StringEncoding;

@implementation LSHttpDuty

+(NSTimeInterval)getCustomTimeout{
    id ct=[[NSUserDefaults standardUserDefaults]objectForKey:@"custom_timeout"];
    if(ct){
        custom_timeout=[ct doubleValue];
    }
    return custom_timeout;
}
+(void)setCustomTimeout:(NSTimeInterval)ct{
    if(ct>0){
        custom_timeout=ct;
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:ct] forKey:@"custom_timeout"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

+(void)setCustomEncoding:(NSStringEncoding)se{
    custom_encoding=se;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:se] forKey:@"custom_encoding"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSStringEncoding)getCustomEncoding{
    id ct=[[NSUserDefaults standardUserDefaults]objectForKey:@"custom_encoding"];
    if(ct){
        custom_encoding=[ct unsignedIntegerValue];
        NSLog(@"ct=%@ ce=%d",ct,custom_encoding);
    }
    return custom_encoding;
}

-(id)init{
    self=[super init];
    if(self){
        _dutyName=@"";
        _URL=@"";//@"http://www.everstray.com/include/io_debug.php";
        _username=@"";
        _password=@"";
        _headerArray=[[NSMutableArray alloc]init];
        _parameterArray=[[NSMutableArray alloc]init];
        _postBody=@"";
        //_method=@"";
    }
    return self;
}
-(void)addHeader:(NSString*)name value:(NSString*)value{
    //[_headerDict setObject:value forKey:name];
    LSHttpDutyKeyValuePair * pair=[[LSHttpDutyKeyValuePair alloc]init];
    [pair setKey:name];
    [pair setValue:value];
    [_headerArray addObject:pair];
    //[self toJSON];
}
-(void)removeHeaderAt:(NSInteger)index{
    if(_headerArray.count>index){
        [_headerArray removeObjectAtIndex:index];
    }
    //[self toJSON];
}
-(void)updateHeader:(NSString*)value forFieldName:(NSString*)fieldName at:(NSInteger)index{
    if(_headerArray.count>index){
        LSHttpDutyKeyValuePair*pair=[_headerArray objectAtIndex:index];
        if(fieldName)[pair setKey:fieldName];
        if(value)[pair setValue:value];
        [_headerArray replaceObjectAtIndex:index withObject:pair];
    }
    //[self toJSON];
}
-(void)addParameter:(NSString*)name value:(NSString*)value{
    //[_parameterDict setObject:value forKey:name];
    LSHttpDutyKeyValuePair * pair=[[LSHttpDutyKeyValuePair alloc]init];
    [pair setKey:name];
    [pair setValue:value];
    [_parameterArray addObject:pair];
    [self toJSON];
}
-(void)removeParameterAt:(NSInteger)index{
    if(_parameterArray.count>index){
        [_parameterArray removeObjectAtIndex:index];
    }
    //[self toJSON];
}
-(void)updateParameter:(NSString*)value forName:(NSString *)name at:(NSInteger)index{
    if(_parameterArray.count>index){
        LSHttpDutyKeyValuePair*pair=[_parameterArray objectAtIndex:index];
        if(value)[pair setValue:value];
        if(name)[pair setKey:name];
        [_parameterArray replaceObjectAtIndex:index withObject:pair];
    }
    //[self toJSON];
}
-(NSString*)toJSON{
//    NSLog(@"LSHttpDuty toJson");
    NSMutableArray * headers=[[NSMutableArray alloc]init];
    if(_headerArray && [_headerArray count]>0){
        for (LSHttpDutyKeyValuePair * header in _headerArray) {
//            NSLog(@"header = %@",header);
            //if([header isKindOfClass:[LSHttpDutyKeyValuePair class]]){
            [headers addObject:[header intoDictionary]];
            //}
        }
    }
    
    NSMutableArray * parameters=[[NSMutableArray alloc]init];
    if(_parameterArray && [_parameterArray count]>0){
        for (LSHttpDutyKeyValuePair* parameter in _parameterArray) {
            //if([parameter isKindOfClass:[LSHttpDutyKeyValuePair class]]){
            [parameters addObject:[parameter intoDictionary]];
            //}
        }
    }
//    NSLog(@"LSHttpDuty toJson prepared as dutyName=%@, URL=%@, username=%@, password=%@, headerArray=%@, parameterArray=%@, postBody=%@",_dutyName,_URL,_username,_password,_headerArray,_parameterArray,_postBody);
    NSDictionary * dict=@{@"dutyName": _dutyName,
                          @"URL":_URL,
                          @"username":_username,
                          @"password":_password,
                          @"headerArray":[NSArray arrayWithArray:headers],//_headerArray,
                          @"parameterArray":[NSArray arrayWithArray:parameters],//_parameterArray,
                          @"postBody":_postBody,
                          //@"method":_method
                          };
    NSError * error=nil;
    NSData*data=[NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:&error];
    NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"LSHttpDuty into JSON:\n%@",str);
    return str;
}
-(BOOL)checkValue{
    BOOL b1 = (
     _dutyName && _URL && _username && _password
    && _headerArray && _password
    && _postBody
            );
    if(!b1)return NO;
    if([_headerArray count]>0){
        for (LSHttpDutyKeyValuePair * pair in _headerArray) {
            if(![pair key] || ![pair value]){
                return NO;
            }
        }
    }
    if([_parameterArray count]>0){
        for (LSHttpDutyKeyValuePair * pair in _parameterArray) {
            if(![pair key] || ![pair value]){
                return NO;
            }
        }
    }
    return YES;
}
+(LSHttpDuty*)httpDutyFromJSONDict:(NSDictionary*)dict{
    LSHttpDuty* httpDuty=[[LSHttpDuty alloc]init];
    [httpDuty setDutyName:dict[@"dutyName"]];
    [httpDuty setURL:dict[@"URL"]];
    [httpDuty setUsername:dict[@"username"]];
    [httpDuty setPassword:dict[@"password"]];
    [httpDuty setPostBody:dict[@"postBody"]];
    
    NSArray * headers =dict[@"headerArray"];
    if(headers && [headers count]>0){
        for (NSDictionary * pair in headers) {
            NSString * key = pair[@"key"];
            NSString * value = pair[@"value"];
            [httpDuty addHeader:key value:value];
        }
    }
    
    NSArray * params =dict[@"parameterArray"];
    if(params && [params count]>0){
        for (NSDictionary * pair in params) {
            NSString * key = pair[@"key"];
            NSString * value = pair[@"value"];
            [httpDuty addParameter:key value:value];
        }
    }
    if([httpDuty checkValue]){
        return httpDuty;
    }
    else{
        return nil;
    }
}

-(NSDictionary*)submitWithMethod:(NSString*)method withTimeout:(NSTimeInterval)timeout{
    if(!_URL || [_URL isEqualToString:@""]){
        NSDictionary * r=  @{@"submit": @NO,@"data":@"No available URL!"};
        //        NSLog(@"MISI >> %@",r);
        return r;
    }
    if([method isEqualToString:@"GET"]){
        NSString * url=_URL;
        NSString * body=@"";
        if(_parameterArray && [_parameterArray count]>0){
            for (LSHttpDutyKeyValuePair * pair in _parameterArray) {
                NSString * kv=[NSString stringWithFormat:@"%@=%@",pair.key,pair.value];
                if([body isEqualToString:@""]){
                    body = [body stringByAppendingString:kv];
                }else{
                    body = [[body stringByAppendingString:@"&"] stringByAppendingString:kv];
                }
            }
        }
        if(body && ![body isEqualToString:@""]){
            url=[[url stringByAppendingString:@"?"]stringByAppendingString:body];
        }
        
        NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:timeout];
        
        NSString * AuthorizationHeader=nil;
        if(![_username isEqualToString:@""] && ![_password isEqualToString:@""]){
            AuthorizationHeader=[NSString stringWithFormat:@"Basic %@",[LSHttpDuty base64Encode:[NSString stringWithFormat:@"%@:%@",_username,_password]]];
        }
        if(_headerArray && [_headerArray count]>0){
            for (LSHttpDutyKeyValuePair * pair in _headerArray) {
                if([pair.key isEqualToString:@"Authorization"] && AuthorizationHeader){
                    [request addValue:pair.value forHTTPHeaderField:AuthorizationHeader];
                }else
                    [request addValue:pair.value forHTTPHeaderField:pair.key];
            }
        }
        [request setHTTPMethod:method];
        
        NSURLResponse * response=nil;
        NSError * error=nil;
        
        NSDate * startDate= [NSDate date];
        
        NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDate * endDate= [NSDate date];
        NSTimeInterval t=[endDate timeIntervalSinceDate:startDate];
        
        NSDictionary * r;
        if(response){
            r= @{@"submit": @YES,
                 @"data":data?data:[NSNull null],
                 @"response":(response && (![response isEqual:[NSNull null]]))?response:[NSNull null],
                 @"time_spend":[NSNumber numberWithDouble:t],
                 @"error":error?error:[NSNull null],
                 @"method":@"GET"};
        }else{
            r=  @{@"submit": @NO,@"data":@"Cannot connect to target!"};
        }
//        NSLog(@"GET >> %@",r);
        
        NSDictionary *dict = @{@"url" : url};
        [MobClick event:@"DUTY_GET" attributes:dict];
        
        return r;
        
    }else if([method isEqualToString:@"POST"]){
        NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_URL] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:timeout];
        
        NSString * content_type=nil;
        NSString * content_length=nil;
        
        NSString * AuthorizationHeader=nil;
        if(![_username isEqualToString:@""] && ![_password isEqualToString:@""]){
            AuthorizationHeader=[NSString stringWithFormat:@"Basic %@",[LSHttpDuty base64Encode:[NSString stringWithFormat:@"%@:%@",_username,_password]]];
        }
        if(_headerArray && [_headerArray count]>0){
            for (LSHttpDutyKeyValuePair * pair in _headerArray) {
                if([pair.key isEqualToString:@"Authorization"] && AuthorizationHeader){
                    [request addValue:pair.value forHTTPHeaderField:AuthorizationHeader];
                }else
                    [request addValue:pair.value forHTTPHeaderField:pair.key];
                if([pair.key isEqualToString:@"Content-Type"]){
                    content_type=pair.value;
                }
                //            USE REAL CONTENT LENGTH
                //            else if ([pair.key isEqualToString:@"Content-Length"]){
                //                content_length=pair.value;
                //            }
            }
        }
        NSString * body = @"";
        
        if([method isEqualToString:@"POST"] && _postBody && ![_postBody isEqualToString:@""]){
            body=[body stringByAppendingString:_postBody];
        }
        
        
        if(_parameterArray && [_parameterArray count]>0){
            for (LSHttpDutyKeyValuePair * pair in _parameterArray) {
                
                NSString * kv=[NSString stringWithFormat:@"%@=%@",pair.key,pair.value];
                if([@"application/x-www-form-urlencoded" isEqualToString:content_type]){
                    NSString *key = [LSHttpDuty urlEncode:pair.key];
                    NSString *value = [LSHttpDuty urlEncode:pair.value];
                    kv=[NSString stringWithFormat:@"%@=%@",key,value];
                }
                
                if([body isEqualToString:@""]){
                    body = [body stringByAppendingString:kv];
                }else{
                    body = [[body stringByAppendingString:@"&"] stringByAppendingString:kv];
                }
            }
        }
        NSData* bodyData=[body dataUsingEncoding:NSUTF8StringEncoding];
        if(!content_length){
            content_length=[NSString stringWithFormat:@"%d",[bodyData length]];
            [request setValue:content_length forHTTPHeaderField:@"Content-Length"];
        }
        
        [request setHTTPBody:bodyData];
        
        [request setHTTPMethod:method];
        
        NSURLResponse * response=nil;
        NSError * error=nil;
        
        NSDate * startDate= [NSDate date];
        
        NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDate * endDate= [NSDate date];
        NSTimeInterval t=[endDate timeIntervalSinceDate:startDate];
        
        NSDictionary * r;
        if(response){
            r = @{@"submit": @YES,
                  @"data":data?data:[NSNull null],
                  @"response":(response && (![response isEqual:[NSNull null]]))?response:[NSNull null],
                  @"time_spend":[NSNumber numberWithDouble:t],
                  @"error":error?error:[NSNull null],
                  @"method":@"POST"};
        }else{
            r=  @{@"submit": @NO,@"data":@"Cannot connect to target!"};
        }
//        NSLog(@"POST >> %@",r);
        
        NSDictionary *dict = @{@"url" : _URL};
        [MobClick event:@"DUTY_POST" attributes:dict];
        
        return r;
    }else{
        NSDictionary * r=  @{@"submit": @NO,@"data":@"Method is neither GET nor POST!"};
//        NSLog(@"MISI >> %@",r);
        return r;
    }
}

+(NSString*)urlEncode:(NSString*)plain{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)plain, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}
+(NSString*)base64Encode:(NSString*)plainString{
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
//    NSLog(@"%@", base64String); // Zm9v
    return base64String;
}
+(NSString*)base64Decode:(NSString*)base64String{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", decodedString); // foo
    return decodedString;
}

@end

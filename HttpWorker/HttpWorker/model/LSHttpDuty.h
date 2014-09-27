//
//  LSHttpDuty.h
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-22.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_EXPORT
CFStringRef CFURLCreateStringByAddingPercentEscapes(CFAllocatorRef allocator, CFStringRef originalString, CFStringRef charactersToLeaveUnescaped, CFStringRef legalURLCharactersToBeEscaped, CFStringEncoding encoding);

@interface LSHttpDutyKeyValuePair : NSObject//NSMutableDictionary
//-(id)getKey;
//-(id)getValue;
//-(void)setKey:(NSString*)v;
//-(void)setValue:(NSString*)v;
@property NSString * key;
@property NSString * value;

-(NSDictionary*)intoDictionary;
@end

@interface LSHttpDuty : NSObject

@property NSString * dutyName;
@property NSString * URL;
@property NSString * username;
@property NSString * password;
@property NSMutableArray * headerArray;
@property NSMutableArray * parameterArray;
@property NSString * postBody;
//@property NSString * method;

+(void)setCustomTimeout:(NSTimeInterval)ct;
+(NSTimeInterval)getCustomTimeout;

+(void)setCustomEncoding:(NSStringEncoding)se;
+(NSStringEncoding)getCustomEncoding;

-(void)addHeader:(NSString*)name value:(NSString*)value;
-(void)updateHeader:(NSString*)value forFieldName:(NSString*)fieldName at:(NSInteger)index;
-(void)removeHeaderAt:(NSInteger)index;
-(void)addParameter:(NSString*)name value:(NSString*)value;
-(void)updateParameter:(NSString*)value forName:(NSString*)name at:(NSInteger)index;
-(void)removeParameterAt:(NSInteger)index;

-(NSDictionary*)submitWithMethod:(NSString*)method withTimeout:(NSTimeInterval)timeout;
-(NSString*)toJSON;
+(LSHttpDuty*)httpDutyFromJSONDict:(NSDictionary*)dict;

+(NSString*)base64Encode:(NSString*)plainString;
+(NSString*)base64Decode:(NSString*)base64String;
+(NSString*)urlEncode:(NSString*)plain;
@end


@protocol LSHttpDutyVCDelegate <NSObject>

-(void)refreshHttpDuty:(LSHttpDuty*)httpDuty;

@end

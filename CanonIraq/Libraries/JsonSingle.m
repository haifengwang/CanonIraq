//
//  JsonSingle.m
//  CanonIraq
//
//  Created by onskyline on 14-6-18.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "JsonSingle.h"

@implementation JsonSingle
@synthesize jsonDic;
static  JsonSingle *instance = nil;

+(JsonSingle*)shareInstance
{
    if (!instance) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

- (id)init
{
    if (instance) {
        
        return instance;
    }
    self = [super init];
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [[self shareInstance] retain];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain
{
    return self;
}

-(NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release{//oneway关键字只用在返回类型为void的消息定义中， 因为oneway是异步的，其消息预计不会立即返回。
    //什么都不做
}


- (void)dealloc
{
    [jsonDic release];
    [super dealloc];
}

@end

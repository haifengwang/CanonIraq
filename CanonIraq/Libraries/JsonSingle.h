//
//  JsonSingle.h
//  CanonIraq
//
//  Created by onskyline on 14-6-18.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonSingle : NSObject

@property (nonatomic,retain)NSDictionary* jsonDic;

+(JsonSingle*)shareInstance;

@end

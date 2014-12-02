//
//  EpubRecordManager.h
//  CanonIraq
//  阅读记录数据处理
//  Created by onskyline on 14-6-13.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpubRecord.h"
#import "RecordField.h"

@interface EpubRecordManager : NSObject

//初始化记录
- (id)initWithRecordName:(NSString *)recodeName;
//添加记录
- (BOOL)addRecord:(EpubRecord *)record;
//最后阅读记录
- (EpubRecord *)lastRecord;

@end

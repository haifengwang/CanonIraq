//
//  EpubRecord.h
//  CanonIraq
//  用于记录阅读记录的数据结构
//  Created by onskyline on 14-6-12.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RecordField.h"

@interface EpubRecord : NSObject

@property (nonatomic, readonly) NSInteger recordID;                         //记录ID.
@property (nonatomic, assign)   NSInteger  currentSpineIndex;              //当前epubSpine
@property (nonatomic, assign)   NSInteger  currentPageInSpineIndex;       //当前Spine中得页码
@property (nonatomic, assign)   NSInteger    pagesInCurrentSpineCount;   //当前Spine的总页码
@property (nonatomic, assign)   NSInteger currentTextSize;              //当前的字体大小
@property (nonatomic, strong)   NSString    *lastReadTime;               //最后阅读时间
@property (nonatomic,assign)    NSInteger pageInAll;                  //当前全书的中阅读到得页码
@property (nonatomic,assign)    NSInteger bookId;                    // 书籍ID



//初始化阅读记录
- (id)initWithRecordID:(NSInteger)recordID;

@end

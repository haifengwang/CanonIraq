//
//  EpubRecord.m
//  CanonIraq
//
//  Created by onskyline on 14-6-12.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "EpubRecord.h"

@implementation EpubRecord


- (id)initWithRecordID:(NSInteger)recordID
{
    self = [self init];
    _recordID = recordID;
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
//    [encoder encodeObject:self.markName forKey:kMarkName];
    [encoder encodeInteger:self.bookId forKey:BookId];
    [encoder encodeInteger:self.recordID forKey:RecordId];
    [encoder encodeInteger:self.currentSpineIndex forKey:SpineIndex];
    [encoder encodeInteger:self.currentPageInSpineIndex forKey:PageInSpineIndex];
    [encoder encodeInteger:self.pagesInCurrentSpineCount forKey:SpineCount];
    [encoder encodeInteger:self.currentTextSize forKey:TextSize];
    [encoder encodeObject:self.lastReadTime forKey:LastReadTime];
    [encoder encodeInteger:self.pageInAll forKey:PageInAll];
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
//        self.markName = [decoder decodeObjectForKey:kMarkName];
        self.bookId=[decoder decodeIntegerForKey:BookId];
        _recordID=[decoder decodeIntegerForKey:RecordId];
        self.currentSpineIndex=[decoder decodeIntegerForKey:SpineIndex];
        self.currentPageInSpineIndex=[decoder decodeIntegerForKey:PageInSpineIndex];
        self.pagesInCurrentSpineCount=[decoder decodeIntegerForKey:PageInSpineIndex];
        self.currentTextSize=[decoder decodeIntegerForKey:TextSize];
        self.lastReadTime=[decoder decodeObjectForKey:LastReadTime];
        self.pageInAll=[decoder decodeIntegerForKey:PageInAll];
    }
    
    return self;
}


@end

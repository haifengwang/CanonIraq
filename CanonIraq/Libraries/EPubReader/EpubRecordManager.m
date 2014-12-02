//
//  EpubRecordManager.m
//  CanonIraq
//
//  Created by onskyline on 14-6-13.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "EpubRecordManager.h"
#import "FMDatabase.h"
#import "NSDate+Addition.h"
#import "EPubConfig.h"

@interface EpubRecordManager()

@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSString   *tableName;
@end

@implementation EpubRecordManager

- (id)initWithRecordName:(NSString *)recodeName
{
    self = [self init];
    self.tableName = recodeName;
    self.db = [FMDatabase databaseWithPath:kEPubDBPath];
    [self creatRecordTable];
    
    return self;
}

- (BOOL)creatRecordTable
{
    NSString *sqlKey = [NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY autoincrement,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ INTEGER,%@ vachar(20) ",
                        RecordId,BookId,SpineIndex,PageInSpineIndex,SpineCount,PageInAll,TextSize,LastReadTime];
    BOOL result = NO;
    if ([self.db open])
    {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)", self.tableName, sqlKey];
        result = [self.db executeUpdate:sql];
        if ([self.db hadError])
            NSLog(@"error:%@", [self.db lastError]);
    }
    [self.db close];
    
    return result;
}

-(BOOL)addRecord:(EpubRecord *)record
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (%d,%d,%d,%d,%d,%d,'%@')", self.tableName,BookId,SpineIndex,PageInSpineIndex,SpineCount,PageInAll,TextSize,LastReadTime,
                     record.bookId,
                     record.currentSpineIndex,
                     record.currentPageInSpineIndex,
                     record.pagesInCurrentSpineCount,
                     record.pageInAll,
                     record.currentTextSize,
                     record.lastReadTime
                     ];
    BOOL result = NO;
    if ([self.db open])
    {
        result = [self.db executeUpdate:sql];
        if ([self.db hadError])
            NSLog(@"error:%@", [self.db lastError]);
    }
    [self.db close];
    return result;
}

- (EpubRecord *)lastRecord
{
    
    NSString *sqlKey = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@",
                        RecordId,BookId,SpineIndex,PageInSpineIndex,SpineCount,PageInAll,TextSize,LastReadTime];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ order by RecordId desc limit 1", sqlKey, self.tableName];
    FMResultSet *resultSet = nil;
    EpubRecord *record=[[EpubRecord alloc] init];
    if ([self.db open])
    {
        resultSet = [self.db executeQuery:sql];
        if ([self.db hadError])
            NSLog(@"error:%@", [self.db lastError]);
    }
    
    while ([resultSet next])
    {
        record.bookId=[[resultSet objectForColumnName:BookId] integerValue];
//        NSLog(@"%d",record.bookId);
        record.currentSpineIndex=[[resultSet objectForColumnName:SpineIndex] integerValue];
        record.currentPageInSpineIndex=[[resultSet objectForColumnName:PageInSpineIndex] integerValue];
        record.pagesInCurrentSpineCount=[[resultSet objectForColumnName:SpineIndex]integerValue];
        record.pageInAll=[[resultSet objectForColumnName:PageInAll] integerValue];
        record.currentTextSize=[[resultSet objectForColumnName:TextSize] integerValue];
        record.lastReadTime=[resultSet objectForColumnName:LastReadTime];
    }
    [self.db close];
    NSLog(@"record: %@",[record description]);
    return record;

}


@end

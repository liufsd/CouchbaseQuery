//
//  ContactInfoModel.m
//  TestCLDB
//
//  Created by liu peng on 9/28/14.
//  Copyright (c) 2014 liu peng. All rights reserved.
//

#import "ContactInfoModel.h"


@implementation ContactInfoModel

@dynamic user_id, type, contactData;

- (instancetype) initInDatabase: (CBLDatabase*)database
{
    self = [super initWithNewDocumentInDatabase:database];
    if(self){
        self.type = [[self class] type];
    }
    return self;
}
- (instancetype) initInDatabase: (CBLDatabase*)database
                         withID: (NSString*)thisUserId
{
    
    CBLDocument* doc = [database documentWithID: thisUserId];
    self = [ContactInfoModel modelForDocument:doc];
    
    self.type = [[self class] type];
    self.user_id = thisUserId;       //used for the query explanation shown later
    self.userOlder = arc4random()%10;//test older
    self.progress = 10 * (arc4random()%10);//test pro
    return self;
}
+ (NSString*) type{
    return @"contacInfo";
}
@end
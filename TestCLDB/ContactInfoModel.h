//
//  ContactInfoModel.h
//  TestCLDB
//
//  Created by liu peng on 9/28/14.
//  Copyright (c) 2014 liu peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface ContactInfoModel : CBLModel

@property (strong) NSString* user_id;
@property (strong) NSString* type;
@property (strong) NSString* contactData;
@property (assign) int userOlder;
@property (assign) int progress;
- (instancetype) initInDatabase: (CBLDatabase*)database;
- (instancetype) initInDatabase: (CBLDatabase*)database withID: (NSString*)thisUserId;

@end
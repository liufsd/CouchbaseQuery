//
//  ViewController.m
//  TestCLDB
///Users/liupeng/Documents/workspace/TestCLDB/TestCLDB.xcodeproj
//  Created by liu peng on 9/28/14.
//  Copyright (c) 2014 liu peng. All rights reserved.
//

#import "ViewController.h"
#import "ContactInfoModel.h"
#import <CouchbaseLite/CouchbaseLite.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self checkDatabase];
    
//    [self addNewInfo];
    
    [self doSomeQuery];
}
-(void)checkDatabase
{
    CBLManager *manager = [CBLManager sharedInstance];
    
    NSError *error;
    _database = [manager databaseNamed: @"conektapp_db" error: &error];
    
    if (error) { NSLog(@"error getting database %@",error); }
}
-(void)addNewInfo{
    ContactInfoModel * myContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"N_older_Pro_0"];
    
    myContactInfo.contactData = @"Tel: +4912342340";
    myContactInfo.progress = 75;
    myContactInfo.userOlder = 8;
    
    NSError * error;
    if(![myContactInfo save:&error]) NSLog(@"Error: %@", error.localizedDescription);
    
    ContactInfoModel * zhContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"N_older_Pro_1"];
    
    zhContactInfo.contactData = @"Tel: +4912342341";
    zhContactInfo.progress = 76;
    zhContactInfo.userOlder = 5;
    
    NSError * zherror;
    if(![zhContactInfo save:&zherror]) NSLog(@"Error: %@", zherror.localizedDescription);
    
    ContactInfoModel * liuContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"N_older_Pro_2"];
    
    liuContactInfo.contactData = @"Tel: +4912342342";
    liuContactInfo.progress = 65;
    liuContactInfo.userOlder = 9;
    
    NSError * liuerror;
    if(![liuContactInfo save:&liuerror]) NSLog(@"Error: %@", liuerror.localizedDescription);
    
    ContactInfoModel * lContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"N_older_Pro_3"];
    
    lContactInfo.contactData = @"Tel: +4912342343";
    lContactInfo.progress = 60;
    lContactInfo.userOlder = 8;
    
    NSError * lerror;
    if(![lContactInfo save:&lerror]) NSLog(@"Error: %@", lerror.localizedDescription);
}

- (CBLQuery*) queryContactInfoFromUsername:(NSString*) user
{
    //1- createView
    CBLView * contactInfoView = [self.database viewNamed: @"contactDataByUsername"];
    [contactInfoView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: @"contacInfo"]) {
            if (doc[@"user_id"])
                emit(doc[@"user_id"], doc[@"contactData"]);
        }
    }) version: @"2"];
    
    //2 - make the query
    CBLQuery* query = [contactInfoView createQuery];
    NSLog(@"Querying username: %@", user);
    query.startKey = user;
    query.endKey   = user;
    return query;
}

- (CBLQuery*) queryContactInfoStartUserOlder:(id)startOlder endOlder:(id)endOlder
{
    //1- createView
    CBLView * contactInfoView = [self.database viewNamed: @"contactDataByUserOlder"];
    [contactInfoView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: @"contacInfo"]) {
            if (doc[@"userOlder"])
                emit(doc[@"userOlder"], doc[@"user_id"]);
        }
    }) version: @"3"];
    
    //2 - make the query
    CBLQuery* query = [contactInfoView createQuery];
    NSLog(@"Querying older: %@ ,%@", startOlder,endOlder);
    query.startKey = startOlder;
    query.endKey   = endOlder;
    return query;
}

- (CBLQuery*) queryContactInfoWithPro:(id)pro
{
    //1- createView
    CBLView * contactInfoView = [self.database viewNamed: @"contactDataByProgress"];
    [contactInfoView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: @"contacInfo"]) {
            if (doc[@"progress"] )
                emit(doc[@"progress"], doc);
        }
    }) version: @"1"];
    
    //2 - make the query
    CBLQuery* query = [contactInfoView createQuery];
    NSLog(@"Querying pro: %@", pro);
    query.startKey = pro;
    query.endKey   = @{};
    return query;
}

- (CBLQuery*) queryContactInfoWithPro:(id)pro StartUserOlder:(id)startOlder endOlder:(id)endOlder
{
    //1- createView
    CBLView * contactInfoView = [self.database viewNamed: @"contactDataByProgressAndOlder"];
    [contactInfoView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: @"contacInfo"]) {
           if (doc[@"progress"] && doc[@"userOlder"])
             emit(@[doc[@"progress"], doc[@"userOlder"]], doc);
        }
    }) version: @"3"];
    
    //2 - make the query
    CBLQuery* query = [contactInfoView createQuery];
    NSLog(@"Querying pro:%@ older: %@ ,%@",pro, startOlder,endOlder);
    query.startKey = @[pro,startOlder];
    query.endKey = @[[NSNumber numberWithInteger: 75], endOlder];
    return query;
}

-(void)doSomeQuery
{
    //query userName(user_id)
//    CBLQuery *contactQuery = [self queryContactInfoFromUsername: @"older"];
       //query userOlder(older)
    CBLQuery *contactQuery = [self queryContactInfoStartUserOlder:[NSNumber numberWithInteger: 5] endOlder:[NSNumber numberWithInteger: 10]];
//    CBLQuery *contactQuery = [self queryContactInfoWithPro:[NSNumber numberWithInteger: 60] StartUserOlder:[NSNumber numberWithInteger: 8] endOlder:[NSNumber numberWithInteger: 10]];
//    CBLQuery *contactQuery = [self queryContactInfoWithPro:[NSNumber numberWithInt:0]];
    //run, enumerate
    NSError * error;
    CBLQueryEnumerator* result = [contactQuery run: &error];
    for(CBLQueryRow* row in result)
    {
        NSLog(@"Found document: %@ ,%@", row.document, [row.document properties]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

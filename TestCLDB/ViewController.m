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
    
    [self addNewInfo];
    
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
    ContactInfoModel * myContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database];
    
    myContactInfo.contactData = @"Tel: +4912342342";
    
    NSError * error;
    if(![myContactInfo save:&error]) NSLog(@"Error: %@", error.localizedDescription);
    
    ContactInfoModel * zhContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"zhangsan"];
    
    zhContactInfo.contactData = @"Tel: +4912342343";
    
    NSError * zherror;
    if(![zhContactInfo save:&zherror]) NSLog(@"Error: %@", zherror.localizedDescription);
    
    ContactInfoModel * liuContactInfo = [[ContactInfoModel alloc] initInDatabase:self.database withID:@"liupeng"];
    
    liuContactInfo.contactData = @"Tel: +4912342344";
    
    NSError * liuerror;
    if(![liuContactInfo save:&liuerror]) NSLog(@"Error: %@", liuerror.localizedDescription);
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

-(void)doSomeQuery
{
    CBLQuery *contactQuery = [self queryContactInfoFromUsername: @"liupeng"];
    
    //run, enumerate
    NSError * error;
    CBLQueryEnumerator* result = [contactQuery run: &error];
    for(CBLQueryRow* row in result)
    {
        NSLog(@"Found document: %@", row.document);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

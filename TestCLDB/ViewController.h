//
//  ViewController.h
//  TestCLDB
//
//  Created by liu peng on 9/28/14.
//  Copyright (c) 2014 liu peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>
@interface ViewController : UIViewController

@property(retain,nonatomic) CBLDatabase* database;
@end


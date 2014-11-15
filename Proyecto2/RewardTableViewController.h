//
//  RewardTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 15/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileTableViewController.h"
@interface RewardTableViewController : UITableViewController
@property (nonatomic,strong) PFObject *object;
@end

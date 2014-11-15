//
//  ProfileTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 30/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PlacePrincipalTableViewController.h"
#import "ConfigurationTableViewController.h"
#import "RewardTableViewController.h"
#import "PlaceMainTableViewController.h"
@interface ProfileTableViewController : UITableViewController

@property (nonatomic,strong) PFObject *object;

@end

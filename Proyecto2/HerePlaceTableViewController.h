//
//  HerePlaceTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 30/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Util.h"
#import "PlaceMainTableViewController.h"
#import "HereMapViewController.h"
@interface HerePlaceTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *place;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@end

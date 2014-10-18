//
//  PlacesCategoryTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 07/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PlacesTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlacesCategoryTableViewController : UITableViewController

@property (nonatomic,strong) PFObject *ObjetoC;

@end

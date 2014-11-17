//
//  PlacesTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 28/07/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Util.h"
#import "PlaceMainTableViewController.h"
@interface PlacesTableViewController : UITableViewController

@property (nonatomic,strong) PFObject *categoriaObject;




@end

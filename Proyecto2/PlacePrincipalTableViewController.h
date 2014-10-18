//
//  PlacePrincipalTableViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 01/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Annotation.h"
@interface PlacePrincipalTableViewController : UITableViewController <MKMapViewDelegate>

@property (nonatomic,strong) PFObject *lugar;
@property (nonatomic,strong) PFObject *medall;
@end

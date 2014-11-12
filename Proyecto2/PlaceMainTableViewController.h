//
//  PlaceMainTableViewController.h
//  Proyecto2
//
//  Created by Daniel Alvarez on 12/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Annotation.h"

@interface PlaceMainTableViewController : UITableViewController <MKMapViewDelegate>

@property (nonatomic,strong) PFObject *lugar;

@end

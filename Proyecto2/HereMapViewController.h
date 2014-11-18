//
//  HereMapViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 17/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <MapKit/MKAnnotation.h>
@interface HereMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) NSArray *arrayPlaces;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

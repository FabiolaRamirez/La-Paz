//
//  MapDetailPlaceViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 27/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <MapKit/MKAnnotation.h>
@import CoreLocation;

@interface MapDetailPlaceViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) PFObject *categoriaObject;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

//
//  VistaPrincipalViewController.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 29/06/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VistaPrincipalViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *VistaMapa;

@end

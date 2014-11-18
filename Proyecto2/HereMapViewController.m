//
//  HereMapViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 17/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "HereMapViewController.h"

@interface HereMapViewController()

@end
@implementation HereMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.mapView.delegate=self;
    [self.mapView setShowsUserLocation:YES];
    //_locationManager.delegate = self;
    
    NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
    
    
    
            CLLocationCoordinate2D Localizacion;
            for (PFObject *object in self.arrayPlaces)
            {
                PFGeoPoint *geoPoint = (PFGeoPoint *)[object objectForKey:@"coordinate"];
                
               
                NSString *nombre = (NSString *)[object objectForKey:@"name"];
                NSString *descripcion = (NSString *)[object objectForKey:@"address"];
    
                NSLog(@"nombre: %@  descripcion: %@", nombre, descripcion);
                
                float latitude1 = geoPoint.latitude;
                float longitude1 = geoPoint.longitude;
                
                //estructurando la annotation
                Annotation *miAnotacion=[[Annotation alloc] init];
                Localizacion.latitude=latitude1;
                Localizacion.longitude=longitude1;
                miAnotacion.coordinate=Localizacion;
                
                miAnotacion.title = nombre;
                miAnotacion.subtitle = descripcion;
                
                MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(Localizacion, 9500, 9500);
                //Enviar vistadel mapa
                [self.mapView setRegion:miRegion1 animated:YES];
                //miAnotacion.subtitle=(NSString *)place[@"name"];
                [VectorAnotaciones addObject:miAnotacion];
                [self.mapView addAnnotations:VectorAnotaciones];
                NSLog(@" Latitud: %f", latitude1);
                NSLog(@" Longitud: %f", longitude1);
            }
    
    
}

@end


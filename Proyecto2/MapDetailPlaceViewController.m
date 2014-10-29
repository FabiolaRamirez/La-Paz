//
//  MapDetailPlaceViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 27/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "MapDetailPlaceViewController.h"

@interface MapDetailPlaceViewController ()
{
    NSMutableArray * VectorPlaces;
    
}
@end
@implementation MapDetailPlaceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VectorPlaces = [[NSMutableArray alloc] init];
    
    self.mapView.delegate=self;
    //_locationManager.delegate = self;
    
    NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
    
    NSString *dodex = self.categoriaObject[@"code"];
    NSLog(@"code!!!!!!!!!!!!!!!!!%@",dodex);
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"code" equalTo:dodex];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            CLLocationCoordinate2D Localizacion;
            for (PFObject *object in objects)
            {
                PFGeoPoint *geoPoint = (PFGeoPoint *)[object objectForKey:@"coordinate"];
                
                // asi se saca el titulo y la desc, igual que que el geopoint, osea igual que en todos los quetys que ya hicimos antes en las otras pantallas
                NSString *nombre = (NSString *)[object objectForKey:@"name"];
                NSString *descripcion = (NSString *)[object objectForKey:@"description"];
                // ahora puedes usar esas variables donde sea...
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
                //miAnotacion.subtitle=(NSString *)place[@"name"];
                [VectorAnotaciones addObject:miAnotacion];
                [self.mapView addAnnotations:VectorAnotaciones];
                NSLog(@" Latitud: %f", latitude1);
                NSLog(@" Longitud: %f", longitude1);
            }
            
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];

    
}


@end

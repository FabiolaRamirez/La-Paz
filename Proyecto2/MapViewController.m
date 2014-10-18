//
//  MapViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 10/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    NSMutableArray * VectorAnotaciones;
    
}
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
     
    self.mapView.delegate=self;
    _locationManager.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    [self.locationManager startUpdatingLocation];
    
    
    
  
    //self.mapView.delegate=self;
    [self.mapView setShowsUserLocation:YES];
    NSLog(@"****************");
    NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
    
    
    PFGeoPoint *geoPoint=[self.Object objectForKey:@"coordinate"];
    
    NSString *nombre = (NSString *)[self.Object objectForKey:@"name"];
    NSString *descripcion = (NSString *)[self.Object objectForKey:@"description"];
    // ahora puedes usar esas variables donde sea...
    NSLog(@"nombre: %@  descripcion: %@", nombre, descripcion);
    
    float latitude1 = geoPoint.latitude;
    float longitude1 = geoPoint.longitude;
    CLLocationCoordinate2D Localizacion;
    
    
    //vector para annotaciones mapa
    VectorAnotaciones=[[NSMutableArray alloc] init];
    //estructurando la annotation
    Annotation *miAnotacion=[[Annotation alloc] init];
    
    Localizacion.latitude=latitude1;
    Localizacion.longitude=longitude1;
    
    miAnotacion.coordinate=Localizacion;
    
    miAnotacion.title = nombre;
    miAnotacion.subtitle = descripcion;
    //miAnotacion.subtitle=(NSString *)place[@"name"];
    MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(Localizacion, 500, 500);
    //Enviar vistadel mapa
    [_mapView setRegion:miRegion1 animated:YES];
    
    [VectorAnotaciones addObject:miAnotacion];
    [_mapView addAnnotations:VectorAnotaciones];







}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //obteniendo coordenadas
    CLLocationCoordinate2D miLocalizacionCoordenada1=[userLocation coordinate];
    //zoom en la region
    MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(miLocalizacionCoordenada1, 9500, 9500);
    //Enviar vistadel mapa
    [self.mapView setRegion:miRegion1 animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

@end

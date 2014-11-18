//
//  VistaPrincipalViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 29/06/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "VistaPrincipalViewController.h"
#import "Annotation.h"
#import "SearchTableViewController.h"
#import <Parse/Parse.h>
#import "HerePlaceTableViewController.h"

@interface VistaPrincipalViewController ()

- (IBAction)listaSuperiorButton:(UIBarButtonItem *)sender;

@end


@implementation VistaPrincipalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //mostrando vista de mapa
    self.VistaMapa.delegate=self;
    [self.VistaMapa setShowsUserLocation:YES];
    NSLog(@"****************");
    NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            CLLocationCoordinate2D Localizacion;
            for (PFObject *object in objects)
            {
                PFGeoPoint *geoPoint = (PFGeoPoint *)[object objectForKey:@"coordinate"];
                
                // asi se saca el titulo y la desc, igual que que el geopoint, osea igual que en todos los quetys que ya hicimos antes en las otras pantallas
                NSString *nombre = (NSString *)[object objectForKey:@"name"];
                NSString *descripcion = (NSString *)[object objectForKey:@"address"];
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
               /* MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(Localizacion, 9000, 9000);
                //Enviar vistadel mapa
                [self.VistaMapa setRegion:miRegion1 animated:YES];*/
                [VectorAnotaciones addObject:miAnotacion];
                [self.VistaMapa addAnnotations:VectorAnotaciones];
                NSLog(@" Latitud: %f", latitude1);
                NSLog(@" Longitud: %f", longitude1);
            }
            
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}
            // Log details of the failure
            
            //metodo mostrar User Location

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //obteniendo coordenadas
    CLLocationCoordinate2D miLocalizacionCoordenada1=[userLocation coordinate];
    //zoom en la region
    MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(miLocalizacionCoordenada1, 9000, 9000);
    //Enviar vistadel mapa
    [self.VistaMapa setRegion:miRegion1 animated:YES];
    
}
//**

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buscar:(UIBarButtonItem *)sender {
 // push
  //  SearchTableViewController *viewController = [[SearchTableViewController alloc] init];
    SearchTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchTableViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)listaSuperiorButton:(UIBarButtonItem *)sender {
    
    HerePlaceTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"herePlaceTableViewController"];
    
    [self.navigationController pushViewController:tableViewController animated:YES];

}
@end

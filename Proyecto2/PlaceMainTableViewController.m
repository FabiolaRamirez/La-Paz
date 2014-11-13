//
//  PlaceMainTableViewController.m
//  Proyecto2
//
//  Created by Daniel Alvarez on 12/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PlaceMainTableViewController.h"
#import "InformationPlace2TableViewController.h"
#import "InformationPlaceTableViewController.h"

@interface PlaceMainTableViewController () {
    NSArray *objectArray;
    NSMutableArray *codigosLugaresArray;
    NSArray *placesArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *fotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *tituloLabel;
@property (weak, nonatomic) IBOutlet UILabel *conquistarLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *texto1MapLabel;
@property (weak, nonatomic) IBOutlet UILabel *texto2MapLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *conquista1Label;
@property (weak, nonatomic) IBOutlet UILabel *conquista2Label;
@property (weak, nonatomic) IBOutlet UILabel *texto3MapLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *conquistaActivityIndicator;

@end

@implementation PlaceMainTableViewController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    //vector para celdas
    objectArray=[[NSMutableArray alloc] initWithCapacity:5];
    codigosLugaresArray = [[NSMutableArray alloc] init];
    placesArray = [[NSMutableArray alloc] init];
    
    
    
    [self setData]; // colocar datos
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setData {
    NSString* cod = self.lugar[@"code"];
    
    NSLog(@"> Tipo %@ ", cod);
    
    
    // titulo
    self.tituloLabel.text = self.lugar[@"name"];
    
    // foto
    PFFile *imageFile = [self.lugar objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            self.fotoImageView.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
    // texto conquistar
    self.conquistarLabel.text = @""; // inicia vacio porque luego se coloca valor
    [self isConquest]; // pregunta si esta conquistado el lugar, para ver si habilitar el boton de conquistar
    
    
    
    
    // mapa y textos
    self.texto1MapLabel.text = self.lugar[@"address"];
    self.texto2MapLabel.text = @""; // que le pondras
    
    PFGeoPoint *geoPoint=[self.lugar objectForKey:@"coordinate"];
    
    float latitude1 = geoPoint.latitude;
    float longitude1 = geoPoint.longitude;
    CLLocationCoordinate2D Localizacion;
    
    //vector para annotaciones mapa
    NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
    //estructurando la annotation
    Annotation *miAnotacion=[[Annotation alloc] init];
    Localizacion.latitude = latitude1;
    Localizacion.longitude = longitude1;
    
    miAnotacion.coordinate=Localizacion;
    
    miAnotacion.title = self.lugar[@"name"];
    miAnotacion.subtitle = self.lugar[@"address"];
    //miAnotacion.subtitle=(NSString *)place[@"name"];
    MKCoordinateRegion miRegion1= MKCoordinateRegionMakeWithDistance(Localizacion, 500, 500);
    //Enviar vistadel mapa
    [self.mapView setRegion:miRegion1 animated:YES];
    
    [VectorAnotaciones addObject:miAnotacion];
    [self.mapView addAnnotations:VectorAnotaciones];
    NSLog(@" Latitud: %f", latitude1);
    NSLog(@" Longitud: %f", longitude1);
    
    [self getUserLocation:geoPoint];
    
    
    

    
    // info
    self.infoLabel.text = self.lugar[@"introduction"];
    
    // conquistas y otros
    self.conquista1Label.text = @"";
    self.conquista2Label.text = @"";
    
    [self getNroUsuariosQueConquistaronEsteLugar]; // para colocar nro de conquistas
    
}



// cuando se presiona conquistar
- (void) conquistar {
    
    [Util showProgress:self.navigationController.view]; // empieza el progreso
    // obtmer la bucacion del lugar
    PFGeoPoint * placeGeoPoint = self.lugar[@"coordinate"];
    NSLog(@"lugar %f", placeGeoPoint.latitude);
    NSLog(@"%f", placeGeoPoint.longitude);
    
    // obtener ubicacion del usuario
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *userGeoPoint, NSError *error) {
        if (!error) {
            NSLog(@"%f, %f", userGeoPoint.latitude, userGeoPoint.longitude);
            // todo ok
            
            // codigo para calcular la distancia
            
            double distancia = [userGeoPoint distanceInKilometersTo:placeGeoPoint];
            
            NSLog(@"distancia %f km", distancia);
            
            // si se pone 10000 se puede conquistar desde muy lejos
            if (distancia < 10000) {
                
                [self saveConquest]; // guarda en Parse la conquista
                
            } else {
                // Alerta donde no se puede conquistar porque esta fuera de rango
                [Util hideProgress:self.navigationController.view]; // ocultamos el progress
                [Util showError:@"Estas muy lejos para conquistar este lugar" view:self.navigationController.view];
            }
            
        } else {
            NSLog(@"Error al obtener localizacion del ususario");
            
            [Util hideProgress:self.navigationController.view]; // ocultamos el progress
            [Util showError:@"No se puede obtener tu ubucación" view:self.navigationController.view];
        }
    }];
    
    //[self verificarSiExisteMedalla];
    
}

- (IBAction)compartir:(UIBarButtonItem *)sender {
    NSLog(@"compartir presionado.");
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; // para despintar lo presioando
    
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    if (indexPath.row == 0) {
        
    } else if(indexPath.row == 1) {
        // se presiono conquistar
        
        // una forma de preungtar si se conquisto, por que otro metodo le pone texto antes
        if ([self.conquistarLabel.text isEqualToString:@"Conquistar"]) {
            [self conquistar];
        }

        
    } else if(indexPath.row == 2) {
        
        
    } else if(indexPath.row == 3) {
        MapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        //PFObject *p = [objectArray objectAtIndex:indexPath.row];
        viewController.Object = _lugar;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if(indexPath.row == 4) {
        NSString* cod = self.lugar[@"code"];
        
        NSLog(@"> Tipo %@ ", cod);
        
        if ([cod isEqual:@"PARQUEX"]||[cod isEqual:@"PLAZAX"]||[cod isEqual:@"MONUMENTOX"]) {
            InformationPlace2TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"informationPlace2TableViewController"];
            //PFObject *p = [objectArray objectAtIndex:indexPath.row];
            viewController.ObjetoB = self.lugar;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else {
            
            InformationPlaceTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"informationPlaceTableViewController"];
            //PFObject *p = [objectArray objectAtIndex:indexPath.row];
            viewController.ObjetoA = self.lugar;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
}


- (void) getUserLocation: (PFGeoPoint *) ubicacionLugar {
    // obtener ubicacion del usuario
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *userGeoPoint, NSError *error) {
        if (!error) {
            NSLog(@"%f, %f", userGeoPoint.latitude, userGeoPoint.longitude);
            // todo ok
            
            // codigo para calcular la distancia
            
            double distancia = [ubicacionLugar distanceInKilometersTo:userGeoPoint];
            
            NSLog(@"distancia %f km", distancia);
            if (distancia < 1) {
                self.texto2MapLabel.text = @"m";
                double ditanciaMetros = distancia * 1000;
                distancia = ditanciaMetros;
                self.texto3MapLabel.text = [Util number2Decimals:distancia];
            } else {
                self.texto2MapLabel.text = @"km";
                //muestra distancia mayor a 1km
                //countKmLabel.text=[NSString stringWithFormat:@"%g", distancia];
                self.texto3MapLabel.text = [Util number2Decimals:distancia];
            }
            
        } else {
            NSLog(@"Error al obtener localizacion del ususario");
        }
    }];
}


#pragma mark - Parse

- (void) saveConquest {
    NSLog(@"Start saveConquest.");
    PFObject *conquest = [PFObject objectWithClassName:@"Conquest"];
    [conquest setObject:[PFUser currentUser]  forKey:@"user"];
    [conquest setObject:self.lugar forKey:@"place"];
    [conquest setObject:[NSDate date] forKey:@"date"];
    [conquest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [Util hideProgress:self.navigationController.view]; // ocultar el progreso
        
        if(succeeded) {
            NSLog(@"End saveConquest.");
            
            
            [Util showSuccess:@"¡Felicidades! conquistaste este lugar" view:self.navigationController.view];
            
            // colocamos el texto que tya fue conquistado
            self.conquistarLabel.text = @"Conquistado";
            self.conquistarLabel.textColor = [UIColor redColor];
            
        } else {
            NSLog(@"Error (saveConquest): %@", error);
        }
    }];
}

- (void) isConquest { // pregunta si esta conquistado este lugar
    NSLog(@"Start isConquest.");
    
    [self.conquistaActivityIndicator startAnimating]; // empieza a dar vuielta el progreso peque
    
    PFQuery *query = [PFQuery queryWithClassName:@"Conquest"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"place" equalTo:self.lugar];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        NSLog(@"End isConquest.");
        
        [self.conquistaActivityIndicator stopAnimating]; // termina de dar vuelta el progreso peque
        
        if (!error) {
            if (count > 0) { // si esta conquistado si entra aca
                self.conquistarLabel.text = @"Conquistado";
                self.conquistarLabel.textColor = [UIColor redColor];
                
            } else { // no esta conquistado si entra aca
                self.conquistarLabel.text = @"Conquistar";
                self.conquistarLabel.textColor = [UIColor primaryColor];
            }
        } else {
            NSLog(@"Error (isConquest): %@", error);
            
            [Util showConnectionError:self.navigationController.view];
        }
    }];
}


- (void) getNroUsuariosQueConquistaronEsteLugar {
    NSLog(@"Start getNroUsuariosQueConquistaronEsteLugar.");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Conquest"];
    [query whereKey:@"place" equalTo:self.lugar];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        NSLog(@"End getNroUsuariosQueConquistaronEsteLugar.");
        
        if (!error) {
            self.conquista2Label.text = [NSString stringWithFormat:@"%i conquistas", count];
        } else {
            NSLog(@"Error (getNroUsuariosQueConquistaronEsteLugar): %@", error);
        }
    }];
}


@end

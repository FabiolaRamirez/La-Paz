//
//  PlacePrincipalTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 01/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PlacePrincipalTableViewController.h"
#import "InformationPlace2TableViewController.h"
#import "InformationPlaceTableViewController.h"
#import <MapKit/MapKit.h>
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"
@interface PlacePrincipalTableViewController ()
{
    NSArray * objectArray;
    NSMutableArray *codigosLugaresArray;
    NSArray *placesArray;
    JGProgressHUD *HUD;
    JGProgressHUD *HUD2;
    JGProgressHUD *HUD3;
    JGProgressHUD *HUD4;
}


@end

@implementation PlacePrincipalTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //vector para celdas
    objectArray=[[NSMutableArray alloc] initWithCapacity:5];
     codigosLugaresArray = [[NSMutableArray alloc] init];
      placesArray = [[NSMutableArray alloc] init];

    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Ingresando...";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        UIImageView * placeImageView = (UIImageView *)[cell viewWithTag:1];
        UILabel * placeNameLabel = (UILabel *)[cell viewWithTag:2];
        placeNameLabel.text=self.lugar[@"name"];;
        placeNameLabel.textColor = [UIColor whiteColor];
        
        //para obtener imagen
        PFFile *imageFile=[_lugar objectForKey:@"imageFile"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error){
                placeImageView.image=[UIImage imageWithData:data];
                NSLog(@"entra!!");
            }
            else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
        return cell;
    }
    if (indexPath.row == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        return cell;
    }
    
    else if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        UILabel * directionLabel = (UILabel *)[cell viewWithTag:4];
        UILabel * countKmLabel = (UILabel *)[cell viewWithTag:5];
        UILabel * kmLabel = (UILabel *)[cell viewWithTag:8];
        MKMapView * mapView = (MKMapView *)[cell viewWithTag:3];
        
        directionLabel.text=self.lugar[@"address"];
        countKmLabel.text=@"0";
        
        
        PFGeoPoint *geoPoint=[self.lugar objectForKey:@"coordinate"];
        mapView.delegate=self;
        
        // asi se saca el titulo y la desc, igual que que el geopoint, osea igual que en todos los quetys que ya hicimos antes en las otras pantallas
        NSString *nombre = (NSString *)[self.lugar objectForKey:@"name"];
        NSString *descripcion = (NSString *)[self.lugar objectForKey:@"address"];
        // ahora puedes usar esas variables donde sea...
        NSLog(@"nombre: %@  descripcion: %@", nombre, descripcion);
        
        float latitude1 = geoPoint.latitude;
        float longitude1 = geoPoint.longitude;
        CLLocationCoordinate2D Localizacion;
        
        
        //vector para annotaciones mapa
        NSMutableArray * VectorAnotaciones=[[NSMutableArray alloc] init];
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
        [mapView setRegion:miRegion1 animated:YES];
        
        [VectorAnotaciones addObject:miAnotacion];
        [mapView addAnnotations:VectorAnotaciones];
        NSLog(@" Latitud: %f", latitude1);
        NSLog(@" Longitud: %f", longitude1);
        
        
        // obtener ubicacion del usuario
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *userGeoPoint, NSError *error) {
            if (!error) {
                NSLog(@"%f, %f", userGeoPoint.latitude, userGeoPoint.longitude);
                // todo ok
                
                // codigo para calcular la distancia
                
                double distancia = [geoPoint distanceInKilometersTo:userGeoPoint];
                
                NSLog(@"distancia %f km", distancia);
                if (distancia<1) {
                    kmLabel.text=@"m";
                    double ditanciaMetros=distancia*1000;
                    distancia=ditanciaMetros;
                    countKmLabel.text = [Util number2Decimals:distancia];
                }
                else{
                    //muestra distancia mayor a 1km
                   //countKmLabel.text=[NSString stringWithFormat:@"%g", distancia];
                    countKmLabel.text = [Util number2Decimals:distancia];
                }
                
            } else {
                NSLog(@"Error al obtener localizacion del ususario");
            }
        }];
        
        return cell;
    }
    else if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        UILabel * informationLabel = (UILabel *)[cell viewWithTag:6];
        informationLabel.text=self.lugar[@"introduction"];
        return cell;
    }
    else if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
        UILabel * countFriendsLabel = (UILabel *)[cell viewWithTag:7];
        UILabel * countPeopleLabel = (UILabel *)[cell viewWithTag:8];
        UILabel * countCalifLabel = (UILabel *)[cell viewWithTag:9];
        countFriendsLabel.text=@"0";
        countPeopleLabel.text=@"0";
        countCalifLabel.text=@"0";
        return cell;
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        return 176;
    } else if(indexPath.row==1){
        return 88;
    }
    else if(indexPath.row==2){
        return 88;
    }
    else if(indexPath.row==3){
        return 66;
    }
    else if(indexPath.row==4){
        return 88;
    }
    
    return 44; //cell for comments, in reality the height has to be adjustable
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    if (indexPath.row==2) {
        MapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        //PFObject *p = [objectArray objectAtIndex:indexPath.row];
        viewController.Object = _lugar;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
    NSString* cod=self.lugar[@"code"];
    NSLog(@"esto es code:%@ ",cod);
    if (indexPath.row==3) {
        
        
        if ([cod isEqual:@"PARQUEX"]||[cod isEqual:@"PLAZAX"]||[cod isEqual:@"MONUMENTOX"]) {
            InformationPlace2TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"informationPlace2TableViewController"];
            //PFObject *p = [objectArray objectAtIndex:indexPath.row];
            viewController.ObjetoB = _lugar;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        }else{
            
            InformationPlaceTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"informationPlaceTableViewController"];
            //PFObject *p = [objectArray objectAtIndex:indexPath.row];
            viewController.ObjetoA = _lugar;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    
    
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)conquistarButton:(id)sender {
    
    // obtmer la bucacion del lugar
    PFGeoPoint * placeGeoPoint = self.lugar[@"coordinate"];
    NSLog(@"lugar %f",placeGeoPoint.latitude);
    NSLog(@"%f",placeGeoPoint.longitude);
    
      [HUD showInView:self.view];
    // obtener ubicacion del usuario
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *userGeoPoint, NSError *error) {
        if (!error) {
            NSLog(@"%f, %f", userGeoPoint.latitude, userGeoPoint.longitude);
            // todo ok
            
            // codigo para calcular la distancia
            
            
            double distancia = [userGeoPoint distanceInKilometersTo:placeGeoPoint];
            
            NSLog(@"distancia %f km", distancia);
            
            if (distancia < 0.3) {
                
                [self getConquistasToCurrentUser];
                
            } else {
                [HUD dismissAnimated:YES];
                // Alerta donde no se puede conquistar porque esta fuera de rango
                [self showErrorOutHUD];
            
            }
            
        } else {
            NSLog(@"Error al obtener localizacion del ususario");
            [HUD dismissAnimated:YES];
            [self showErrorInternetHUD];
        }
    }];
    
    //[self verificarSiExisteMedalla];
    
}

- (void) getConquistasToCurrentUser {
    NSLog(@"Se ejecuta getConquistasToCurrentUser");
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        
        PFQuery *query = [PFQuery queryWithClassName:@"Conquista"];
        [query whereKey:@"codigo_user" equalTo:currentUser.objectId];
        
        //[query orderByAscending:@"Tipo"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
                
                NSArray *conquistasArray = objects;
                for (PFObject *conquista in conquistasArray) {
                    [codigosLugaresArray addObject:conquista[@"codigo_place"]];
                }
                
                [self getPlacesFromTheirCodes];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
        
        
    } else {
        // show the signup or login screen
        NSLog(@"error rarro no hay usuario!!!");
    }
}


- (void) getPlacesFromTheirCodes {
    
    NSLog(@"Se ejecuta getPlacesFromTheirCodes");
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"objectId" containedIn:codigosLugaresArray];
    
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            int sw=0;
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            // funciona
             placesArray=objects;
             [self.tableView reloadData];
            
            
            for (int i=0; i<[placesArray count]; i++) {
                PFObject *lugarA = [placesArray objectAtIndex:i];
                
                if ([lugarA.objectId isEqualToString:self.lugar.objectId] ) {
                    sw=1;
                }
                else{
                    
                }
            }
            if (sw==1) {
                [HUD dismissAnimated:YES];
                //Alerta donde ya conquisto ese lugar
                [self showErrorHUD];
                
            }
            else{
                [HUD dismissAnimated:YES];
                //Alerta donde la conquista fue exitosa
                [self showSuccessHUD];
                [self saveToParseConquista];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

- (void) saveToParseConquista {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSLog(@"usuario: %@       lugar: %@", currentUser.objectId, self.lugar.objectId);
        
        PFObject *conquista = [PFObject objectWithClassName:@"Conquista"];
        conquista[@"codigo_user"] = currentUser.objectId;
        conquista[@"codigo_place"] = self.lugar.objectId;
        [conquista saveInBackground];
        
        
        //para refrescar tabla despues de hacer logeo
        [self.tableView reloadData];
        
    } else {
        // show the signup or login screen
        NSLog(@"error raro, no hay usuario");
    }
    
    
}








//-----------------------------------------------

-(void) verificarSiExisteMedalla{
    NSLog(@"Se ejecuta verificarSiExisteMedalla");
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        
        PFQuery *query = [PFQuery queryWithClassName:@"Conquista"];
        [query whereKey:@"codigo_user" equalTo:currentUser.objectId];
        
        //[query orderByAscending:@"Tipo"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
                
                if ([placesArray count]==1) {
                    
                    [self consultaMedallaAsignada];
                }
                else{
                    
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
        
        
    } else {
        // show the signup or login screen
    }
}

-(void) consultaMedallaAsignada{
     _medall = [PFObject objectWithClassName:@"Medalla"];
    NSString *medalla = _medall.objectId;
    NSLog(@".......:::%@",medalla);
    
    //Query
    PFQuery *query = [PFQuery queryWithClassName:@"Medalla"];
    [query whereKey:@"codigo_medall" equalTo:_medall];
    
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            [self saveParseToMedall];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

-(void) saveParseToMedall{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSLog(@"usuario: %@  lugar: %@", currentUser.objectId, self.medall.objectId);
        
        PFObject *medallero = [PFObject objectWithClassName:@"Medallero"];
        medallero[@"codigo_user"] = currentUser.objectId;
        medallero[@"codigo_medall"] = self.medall.objectId;
        [medallero saveInBackground];
        
        
    } else {
        // show the signup or login screen
        NSLog(@"error raro, no hay usuario");
    }

}

- (void)showSuccessHUD {
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    
    HUD.textLabel.text = @"Conquistado";
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:3.0];
}
- (void)showErrorHUD {
    HUD2 = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    
    HUD2.textLabel.text = @"Ya conquiste!";
    HUD2.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD2.square = YES;
    
    [HUD2 showInView:self.navigationController.view];
    
    [HUD2 dismissAfterDelay:2.0];
}
- (void)showErrorOutHUD {
    HUD3 = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    
    HUD3.textLabel.text = @"No esta aqui!";
    HUD3.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD3.square = YES;
    
    [HUD3 showInView:self.navigationController.view];
    
    [HUD3 dismissAfterDelay:2.0];
}

- (void)showErrorInternetHUD {
    JGProgressHUD *HUD2 = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    
    HUD4.textLabel.text = @"Revise su conexión";
    HUD4.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD4.square = YES;
    
    [HUD4 showInView:self.navigationController.view];
    
    [HUD4 dismissAfterDelay:2.0];
}


#pragma mark - lo que hice yo daniel

// este metodo muestra en dialogos las medallas que acaba de ganar al hacer checkin, se puede modificar para para mostrar las medallas del usuario, lo que se necesita del perfil
- (void) checkNewMedallWin {
    NSLog(@"checkNewMedallWin");
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Conquista"];
        [query whereKey:@"codigo_user" equalTo:currentUser.objectId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %i conquistas.", (int)objects.count);
                
                NSMutableArray *codigosConquistasDelUsuario = [[NSMutableArray alloc] init];
                for (int i = 0; i < objects.count; i++) {
                    PFObject *object = [objects objectAtIndex:i];
                    [codigosConquistasDelUsuario addObject:[NSString stringWithFormat:@"%@", object[@"codigo_place"]]];
                }
                
                // adicionamos el id del lugar actual, es que se muestra en la pantalla
                [codigosConquistasDelUsuario addObject:[NSString stringWithFormat:@"%@", self.lugar.objectId]];
                
                NSLog(@"ids lugares: %@", codigosConquistasDelUsuario);
                
                PFQuery *query = [PFQuery queryWithClassName:@"Medalla"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        NSLog(@"Successfully retrieved %i medallas.", (int)objects.count);
                        
                        NSMutableArray *medallasGanadas = [[NSMutableArray alloc] init];
                        
                        for (PFObject *medalla in objects) {
                            NSString *lugar1 = medalla[@"place_code1"];
                            NSString *lugar2 = medalla[@"place_code2"];
                            NSString *lugar3 = medalla[@"place_code3"];
                            NSLog(@"lUGARES %@ %@ %@", lugar1, lugar2, lugar3);
                            NSLog(@"lUGARES %i %i %i", lugar1.length, lugar2.length, lugar3.length);
                            
                            BOOL cumple1 = NO;
                            BOOL cumple2 = NO;
                            BOOL cumple3 = NO;
                            
                            if (lugar1.length > 0) {
                                cumple1 = [self esteString:lugar1 estaEn:codigosConquistasDelUsuario];
                            } else {
                                cumple1 = YES;
                            }
                            if (lugar2.length > 0) {
                                cumple2 = [self esteString:lugar2 estaEn:codigosConquistasDelUsuario];
                            } else {
                                cumple2 = YES;
                            }
                            if (lugar3.length > 0) {
                                cumple3 = [self esteString:lugar3 estaEn:codigosConquistasDelUsuario];
                            } else {
                                cumple3 = YES;
                            }
                            if (cumple1 && cumple2 && cumple3) {
                                [medallasGanadas addObject:medalla];
                            }
                        }
                        
                        [self showMedallasGanadasEnDialogo:medallasGanadas];
                        
                    } else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        NSLog(@"NO HAY USUARIO ERROR RARO");
    }
    
    
}


- (BOOL) esteString:(NSString *) string estaEn:(NSArray *) array {
    for (NSString *s in array) {
        if ([s isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}


- (void) showMedallasGanadasEnDialogo: (NSArray *) medallasGanadas {
    for (PFObject *medalla in medallasGanadas) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"¡Ganaste una medalla!"
                                                           message:medalla[@"name"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"Aceptar"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (IBAction)compartirButton:(UIBarButtonItem *)sender {
    
}





@end

//
//  MedalTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 29/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "MedalTableViewController.h"

@interface MedalTableViewController () <UIAlertViewDelegate> {
    NSArray *medallsArray; // todas las medallas del mundo
    NSArray *misMedallasArray; // mis medallas
    
    
    UIRefreshControl *refreshControl;
    
    PFObject *medallaPresionada;
}

@end

@implementation MedalTableViewController

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
    
    medallsArray = [[NSMutableArray alloc] init];
    misMedallasArray = [[NSMutableArray alloc] init];
    
    [self getMedallasFromParse];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configRefreshControl];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [medallsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel * tituloLabel = (UILabel *)[cell viewWithTag:1];
    UILabel * descripcionLabel = (UILabel *)[cell viewWithTag:2];
    UIImageView * fotoImageView = (UIImageView *)[cell viewWithTag:3];
    UILabel * ganadoLabel = (UILabel *)[cell viewWithTag:4];
    
    PFObject *medal = [medallsArray objectAtIndex:indexPath.row];
    
    
    tituloLabel.text = medal[@"name"];
    descripcionLabel.text = medal[@"description"];
    ganadoLabel.text = [self isMyMedall:medal] ? @"Ganado" : @"";
    //para obtener imagen
    PFFile *imageFile = [medal objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            fotoImageView.image=[UIImage imageWithData:data];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return cell;
}


// verifica si es una de mis medallas
- (BOOL) isMyMedall:(PFObject *) medalla {
    for (PFObject *miMedalla in misMedallasArray) {
        if ([miMedalla.objectId isEqualToString:medalla.objectId]) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    medallaPresionada = [medallsArray objectAtIndex:indexPath.row];
    if ([self isMyMedall:medallaPresionada]) {
        // no hacemos nada
    } else {
        PFRelation *relation = [medallaPresionada relationForKey:@"places"];
        PFQuery *query = [relation query];
        
        [Util showProgress:self.navigationController.view];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [Util hideProgress:self.navigationController.view];
            
            if (!error) {
                NSLog(@"Successfully retrieved %i scores. (press cell)", (int)objects.count);
                
                [self validarSiConquisto:objects];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

// validarSiConquisto
- (void) validarSiConquisto: (NSArray *) placesRequisito {
    
    BOOL swSiGanoMedalla = placesRequisito.count > 0 ? YES : NO;
    NSString *mensaje = @"Para ganar esta medalla te falta conquistar estos lugares:\n"; // armar el mensaje que se mostrara en el dialogo
    
    NSLog(@"validarSiConquisto %i", (int)placesRequisito.count);
    for (PFObject *placeRequisito in placesRequisito) {
        NSLog(@"Place requisitio: %@", placeRequisito);
        int sw = NO;
        for (PFObject *placeConquistado in self.placesConqueredArray) {
            if ([placeConquistado.objectId isEqualToString:placeRequisito.objectId]) {
                sw = YES;
            }
        }
        if (sw) {
            // no hacemos nada
        } else {
            swSiGanoMedalla = NO;
            mensaje = [NSString stringWithFormat:@"%@\n- %@", mensaje, placeRequisito[@"name"]];
        }
    }
    if (swSiGanoMedalla) {
        NSLog(@"si gano");
        // mostramos mensaje con acciones
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¡Te mereces esta esta medalla!"
                                                        message:@"Reclama tu medalla para que se adicione a tu medallero personal"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                              otherButtonTitles:@"Reclamar", nil];
        [alert show];
        
    } else {
        [Util showImportantMessage:@"¡Falta poco!" message:mensaje];
    }
}

// accion que se realiza cuando presionamos Reclamar
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex");
    
    if (buttonIndex == 1) { // preguntamos si exactmanet se presiono el boton Relcamar
        [Util showProgress:self.navigationController.view];
        
        PFObject *gana = [PFObject objectWithClassName:@"Gana"];
        [gana setObject:[PFUser currentUser]  forKey:@"user"];
        [gana setObject:medallaPresionada forKey:@"medalla"];
        [gana setObject:[NSDate date] forKey:@"date"];
        [gana saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [Util hideProgress:self.navigationController.view];
            if (succeeded) {
                [Util showSuccess:[NSString stringWithFormat:@"¡Ahora la medalla \"%@\" es tuya!", medallaPresionada[@"name"]] view:self.navigationController.view];
                [self getMedallasFromParse];
            } else {
                [Util showConnectionError:self.navigationController.view];
            }
        }];
    }
}


-(void) getMedallasFromParse{
    NSLog(@"getMedallasFromParse");
    PFQuery *query = [PFQuery queryWithClassName:@"Medalla"];
    [query orderByAscending:@"name"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Gana"];
            [query2 whereKey:@"user" equalTo:[PFUser currentUser]];
            [query2 includeKey:@"medalla"];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
                if (!error) {
                    NSLog(@"Successfully retrieved %i scores. (query 2)", (int)objects2.count);
                    
                    NSMutableArray *medallas = [[NSMutableArray alloc] init];
                    for (PFObject *gana in objects2) {
                        PFObject *medalla = [gana objectForKey:@"medalla"];
                        [medallas addObject:medalla];
                    }
                    misMedallasArray = medallas;
                    
                    // recien actualizamos las medallas a la rableview
                    medallsArray = objects;
                    [self.tableView reloadData];
                    
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
            
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}


- (IBAction)goProfile:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) configRefreshControl{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
}

- (void) updateData: (id) sender {
    NSLog(@"se ejecuta cuando se suelta con el dedo el refresh");
    
    [self getMedallasFromParse];
}


@end
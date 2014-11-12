//
//  RankingLugaresTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "RankingLugaresTableViewController.h"
#import "SectionPlaceCollectionViewController.h"
#import "UIColor+LaPaz.h"
#import "Util.h"
#import "PlacePrincipalTableViewController.h"
#import "PlaceMainTableViewController.h"

@implementation RankingLugaresTableViewController {
    UISegmentedControl* segmentedControl;
    
    NSArray * places;
}



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
    self.navigationItem.title = @"Lugares";
    places = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self configSegmentedControl];
    
    // llamar la primera vez para que tenga datos
    [self getRanking1PlacesFromParse];
    
}



- (IBAction)goCategories:(UIBarButtonItem *)sender {
    
    SectionPlaceCollectionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sectionPlaceCollectionViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel * nombreLabel = (UILabel *)[cell viewWithTag:1];
    UILabel * direccionLabel = (UILabel *)[cell viewWithTag:2];
    UIImageView * fotoImageView = (UIImageView *)[cell viewWithTag:3];
    UILabel * distanceLabel = (UILabel *)[cell viewWithTag:4];
    UILabel * contador = (UILabel *)[cell viewWithTag:5];
    UILabel * kmLabel = (UILabel *)[cell viewWithTag:6];
    
    PFObject *placeDetail=[places objectAtIndex:indexPath.row];
    
    nombreLabel.text = placeDetail[@"name"];
    direccionLabel.text = placeDetail [@"address"];
    //para obtener imagen
    PFFile *imageFile=[placeDetail objectForKey:@"imageFile"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            fotoImageView.image=[UIImage imageWithData:data];
            NSLog(@"entra!!");
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
    
    
    // obtmer la bucacion del lugar
    PFGeoPoint * placeGeoPoint = placeDetail[@"coordinate"];
    NSLog(@"lugar %f",placeGeoPoint.latitude);
    NSLog(@"%f",placeGeoPoint.longitude);
    
    // obtener ubicacion del usuario
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *userGeoPoint, NSError *error) {
        if (!error) {
            NSLog(@"%f, %f", userGeoPoint.latitude, userGeoPoint.longitude);
            // todo ok
            
            // codigo para calcular la distancia
            
            double distancia = [userGeoPoint distanceInKilometersTo:placeGeoPoint];
            
            NSLog(@"distancia %f km", distancia);
            
            if (distancia<1) {
                kmLabel.text=@"m";
                double ditanciaMetros=distancia*1000;
                distancia=ditanciaMetros;
                distanceLabel.text = [Util number2Decimals:distancia];
            }
            else{
                //muestra distancia mayor a 1km
                //countKmLabel.text=[NSString stringWithFormat:@"%g", distancia];
                distanceLabel.text = [Util number2Decimals:distancia];
            }
            
        } else {
            NSLog(@"Error al obtener localizacion del ususario");
        }
    }];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    
    PFObject *p = [places objectAtIndex:indexPath.row];
    
    
    // push para continuar
    /* antes era asi
    PlacePrincipalTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placePrincipalTableViewController"];
    viewController.lugar = p;
    [self.navigationController pushViewController:viewController animated:YES];
    */
     
    PlaceMainTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placeMainTableViewController"];
    viewController.lugar = p;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
    
    // modal es para salir de contexto
    
    /*
     UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placeViewController"];
     [self presentViewController:viewController animated:YES completion:nil];
     */
}


















- (void) configSegmentedControl {
    NSArray *buttonNames = [NSArray arrayWithObjects:
                            @"Conquistados", @"Populares", @"Recomendados", nil];
    segmentedControl = [[UISegmentedControl alloc]
                        initWithItems:buttonNames];
    segmentedControl.frame = CGRectMake(10, 7, 300, 30);
    [segmentedControl addTarget:self action:@selector(accionSegmentedControl:)               forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = [UIColor primaryColor];
    segmentedControl.selectedSegmentIndex = 0;
    
    UIView *aHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [aHeaderView setBackgroundColor:[UIColor clearColor]];
    [aHeaderView addSubview:segmentedControl];
    
    self.tableView.tableHeaderView = aHeaderView;
}

// este metodo se ejecuta cuando se presiona una seccion
- (void) accionSegmentedControl: (UISegmentedControl *)sender {
    
    NSLog(@"se presiono el %i", sender.selectedSegmentIndex);
    
    if (sender.selectedSegmentIndex == 0) {
        [self getRanking1PlacesFromParse];
    } else if (sender.selectedSegmentIndex == 1) {
        [self getRanking2PlacesFromParse];
    } else if (sender.selectedSegmentIndex == 2) {
        [self getRanking3PlacesFromParse];
    }
    
}



- (void) getRanking1PlacesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByAscending:@"ranking_conquistas"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            places = objects;
            //actualizar tabla con datos
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

- (void) getRanking2PlacesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByAscending:@"ranking_economico"];
    query.limit = 2;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            places = objects;
            //actualizar tabla con datos
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

- (void) getRanking3PlacesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByAscending:@"ranking_recomendados"];
    query.limit = 5;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            places = objects;
            //actualizar tabla con datos
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}







@end

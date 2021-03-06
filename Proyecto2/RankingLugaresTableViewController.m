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
#import "PlaceMainTableViewController.h"

@implementation RankingLugaresTableViewController {
    UISegmentedControl* segmentedControl;
      UIRefreshControl *refreshControl;
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
    
    
      [self configRefreshControl];
    
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"se ejecuta cada rato");
    
    // llamar la primera vez para que tenga datos
    [self getRanking1PlacesFromParse];
}


- (IBAction)GoCategories:(UIBarButtonItem *)sender {
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
    
    //contador del lugar
        if (placeDetail[@"rank"]!=nil) {
        contador.text=[NSString stringWithFormat:@"%@ conquistas ",placeDetail[@"rank"]];
    }
    else{
        contador.text=@"0";
    }
    
    
    // obtner la ubicacion del lugar
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
                double ditanciaMetros=distancia*1000;
                distanceLabel.text = [NSString stringWithFormat:@" a %@ m ",[Util number2Decimals:ditanciaMetros]];
            }
            else{
                //muestra distancia mayor a 1km
                //countKmLabel.text=[NSString stringWithFormat:@"%g", distancia];
                distanceLabel.text = [NSString stringWithFormat:@" a %@ km ",[Util number2Decimals:distancia]];
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
                            @"Más Conquistados", @"Recomendados", nil];
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
    }
}



- (void) getRanking1PlacesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"rank"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
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
    [query orderByDescending:@"ranking_recomendados"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
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

-(void) configRefreshControl{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
}

- (void) updateData: (id) sender {
    NSLog(@"se ejecuta cuando se suelta con el dedo el refresh");
    
    [self getRanking1PlacesFromParse];
    [self getRanking2PlacesFromParse];
}





@end

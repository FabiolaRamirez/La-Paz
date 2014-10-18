//
//  PlacesTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 28/07/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PlacesTableViewController.h"
@interface PlacesTableViewController () {
    NSArray * places;
    NSArray * places_Conquitados;
}

@end

@implementation PlacesTableViewController

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
    
    NSLog(@"se llego");

    places = [[NSMutableArray alloc] init];
    places_Conquitados = [[NSMutableArray alloc] init];
    
    NSString *cate = self.lugar[@"code"];
    
    NSString *nom=self.lugar[@"name"];
    self.navigationItem.title = nom;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"code" equalTo:cate];
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);

            places = objects;
            //actualizar tabla con datos
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    
    //para el contador de lugares conquistados
   
    NSString *cate = placeDetail.objectId;
    NSLog(@".......:::%@",cate);
    
    //Query
    PFQuery *query = [PFQuery queryWithClassName:@"Conquista"];
    [query whereKey:@"codigo_place" equalTo:cate];
    
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved _________%i scores.", (int)objects.count);
            //int cont=(int)objects.count;
            contador.text=[NSString stringWithFormat:@"%d",(int)objects.count];
            
        } else {
            // Log details of the failure
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
            
            distanceLabel.text=[NSString stringWithFormat:@"%g", distancia];
            
        } else {
            NSLog(@"Error al obtener localizacion del ususario");
        }
    }];

    //para obtener el total de conquistas de cada lugar a nivel global
    
    
    
    //[fotoImageView setImageWithURL:[NSURL URLWithString:placeDetail[@"urlImage"]]
      //             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    
    PFObject *p = [places objectAtIndex:indexPath.row];
    
    
  // push para continuar
    PlacePrincipalTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placePrincipalTableViewController"];
    viewController.lugar = p;
    
    [self.navigationController pushViewController:viewController animated:YES];

    
    // modal es para salir de contexto
    
    /*
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placeViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
     */
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

- (NSInteger)contadorLugaresConquistados
{
    NSString *cate = self.lugar.objectId;
    NSLog(@".......:::%@",cate);
    
    //Query
    PFQuery *query = [PFQuery queryWithClassName:@"Categoria"];
    [query whereKey:@"objectId" equalTo:cate];
    
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            places_Conquitados=objects;
        
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];

    NSLog(@"mmmmmmmmmmmm: %lu",(unsigned long)[places_Conquitados count]);
    return [places_Conquitados count];
}

@end

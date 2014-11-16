//
//  ProfileTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 30/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "MedalTableViewController.h"
#import "ConquerCell.h"
#import "UIColor+LaPaz.h"

@interface ProfileTableViewController () {
    NSMutableArray *codigosLugaresArray;
    NSArray *placesArray;
    NSArray *fechasArray;
  
    PFUser *user;
    
    
}

@end

@implementation ProfileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    codigosLugaresArray = [[NSMutableArray alloc] init];
        placesArray = [[NSArray alloc] init];
    fechasArray = [[NSArray alloc] init];
    
    [self setCurrentUser];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"se ejecuta cada rato");
    
    [self getConqueredPlaces];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Querys

/*- (void) getConqueredPlaces { // Se redujo a este metodo sencillo
 NSLog(@"Start getConqueredPlaces.");
 
 PFQuery *query = [PFQuery queryWithClassName:@"Conquest"];
 [query whereKey:@"user" equalTo:[PFUser currentUser]];
 [query includeKey:@"place"]; // es para que el query saque todos los datos de place
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 if (!error) {
 NSLog(@"End getConqueredPlaces. Nro. Places: %i", (int)[objects count]);
 NSMutableArray *places = [[NSMutableArray alloc] init];
 for (PFObject *conquest in objects) {
 PFObject *place = conquest[@"place"];
 [places addObject:place];
 }
 // Update data
 placesArray = places;
 [self.tableView reloadData];
 } else {
 NSLog(@"Error (getConqueredPlaces): %@ %@", error, [error userInfo]);
 }
 }];
 }*/

- (void) getConqueredPlaces { // Se redujo a este metodo sencillo
    NSLog(@"Start getConqueredPlaces.");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Conquest"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"place"]; // es para que el query saque todos los datos de place
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"End getConqueredPlaces. Nro. Places: %i", (int)[objects count]);
            NSMutableArray *places = [[NSMutableArray alloc] init];
            NSMutableArray *fechas = [[NSMutableArray alloc] init]; // este array es temporal, creado aqui
            for (PFObject *conquest in objects) {
                PFObject *place = conquest[@"place"];
                [places addObject:place];
                NSDate *date = conquest[@"date"];
                NSLog(@"imprimiendo date:%@",[self date:date]);
                [fechas addObject:date];
                
                
                // imprimi el date haber
            }
            // Update data
            placesArray = places;
            fechasArray = fechas; // reemplazamos al array global, osea exactamente lo que hicimos con places, osea son 2 arrays uno temporal y otro global
            [self.tableView reloadData];
        } else {
            NSLog(@"Error (getConqueredPlaces): %@ %@", error, [error userInfo]);
        }
    }];
}




- (NSString *)date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMMyyyy"];
    return [[dateFormatter stringFromDate:date] uppercaseString];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return [placesArray count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath");
    
    if (indexPath.section == 0) {
        // hay que devolver la original osea la estatica
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fotoCell" forIndexPath:indexPath];
            
            
            UILabel * nameLabel = (UILabel *)[cell viewWithTag:2];
            UILabel * descriptionLabel = (UILabel *)[cell viewWithTag:3];
            UIImageView * fotoUserImageView = (UIImageView *)[cell viewWithTag:4];
            
            nameLabel.text =user.username;
            nameLabel.textColor = [UIColor primaryDarkColor];
            descriptionLabel.text=user[@"description"];
            //pa inagen de usuario
            PFFile *imageFile=[user objectForKey:@"imageUser"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error){
                    fotoUserImageView.layer.masksToBounds=YES;
                    fotoUserImageView.layer.cornerRadius=30;
                    
                    fotoUserImageView.image=[UIImage imageWithData:data];
                    NSLog(@"entra!!");
                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
            }];
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"botonesCell" forIndexPath:indexPath];
            return cell;
        }
        
        
    } else if (indexPath.section == 1) { // Lista de lugares conquistados
        // section dinamica
        ConquerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conquerCell"];
        
        if (cell == nil) {
            cell = [ConquerCell conquerCell];
            NSDate *date = [fechasArray objectAtIndex:indexPath.row];
            NSLog(@"imprimiendo date:%@",[self date:date]);
            
            PFObject *placeDetail = [placesArray objectAtIndex:indexPath.row];
            cell.dateLabel.text=[self date:date];
            cell.titleLabel.text = placeDetail[@"name"];
            cell.directionLabel.text = placeDetail[@"address"];
            //para obtener imagen
            PFFile *imageFile = [placeDetail objectForKey:@"imageFile"];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error){
                    cell.placeImageView.image = [UIImage imageWithData:data];
                    
                    
                    NSLog(@"entra!!");
                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
            }];
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return 176;
        } else if(indexPath.row==1){
            return 66;
        }
    } else if(indexPath.section==1){
        return 99;
    }
    return 44; //cell for comments, in reality the height has to be adjustable
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    
    PFObject *p = [placesArray objectAtIndex:indexPath.row];
    
    PlaceMainTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placeMainTableViewController"];
    viewController.lugar = p;
    [self.navigationController pushViewController:viewController animated:YES];
    
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

- (IBAction)configurationButton:(id)sender {
    
    ConfigurationTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"configurationTableViewController"];
    
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}


- (IBAction)goRecompensas:(UIButton *)sender {
    
    RewardTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardTableViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}


- (IBAction)goMedallero:(UIButton *)sender {
    NSLog(@"goMedallero");
    
    MedalTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"medalTableViewController"];
    viewController.placesConqueredArray = placesArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}









-(void)setCurrentUser{
    user = [PFUser currentUser];
    if (user) {
        // do stuff with the user
        NSLog(@"Si va todo bien si hay usuario");
    } else {
        // show the signup or login screen
        NSLog(@"No hay usuario error raro");
    }
}



@end

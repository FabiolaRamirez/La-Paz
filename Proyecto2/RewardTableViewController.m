//
//  RewardTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 15/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "RewardTableViewController.h"

@interface RewardTableViewController (){
    //medallas
    NSMutableArray *codigosMedallasArray;
    NSArray *medallasArray;
    NSArray *fechasArray;
    NSMutableArray *medalsArray;
    PFUser *user;
}

@end

@implementation RewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //para medallas
    codigosMedallasArray = [[NSMutableArray alloc] init];
    medallasArray = [[NSArray alloc] init];
    
    //medallas
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [medallasArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel * nombreLabel = (UILabel *)[cell viewWithTag:1];
    UIImageView * fotoImageView = (UIImageView *)[cell viewWithTag:2];

    
    PFObject *object=[medallasArray objectAtIndex:indexPath.row];
    nombreLabel.text=object[@"name"];
    
    //para obtener imagen
    PFFile *imageFile=[object objectForKey:@"imageFile"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            fotoImageView.image=[UIImage imageWithData:data];
            NSLog(@"entra!!");
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];


    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goProfile:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


/*- (void) miMetodo {
    NSLog(@"Start miMetodo.");
    PFObject *gana = [PFObject objectWithClassName:@"Gana"];
    [gana setObject:[PFUser currentUser]  forKey:@"user"];
    PFObject *medalla = [PFObject objectWithClassName:@"Medalla"];
    
    [gana setObject:medalla forKey:@"medalla"];
    [gana setObject:[NSDate date] forKey:@"date"];
    [gana saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded) {
            NSLog(@"se guardo exitosamente.");
            
            
        } else {
            NSLog(@"Error (miMetodo): %@", error);
        }
    }];
}
*/

- (void) getMedallsUser {
    NSLog(@"Start getMedallsUser.");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Gana"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"medalla"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"End getMedallsUser. Nro. medals: %i", (int)[objects count]);
            NSMutableArray *medals = [[NSMutableArray alloc] init];
            NSMutableArray *fechas = [[NSMutableArray alloc] init];
            for (PFObject *gana in objects) {
                PFObject *medalla = gana[@"medalla"];
                [medals addObject:medalla];
                NSDate *date = gana[@"date"];
                NSLog(@"imprimiendo date:%@",[self date:date]);
                [fechas addObject:date];
                
            }
            medalsArray = medals;
            fechasArray = fechas;
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


@end

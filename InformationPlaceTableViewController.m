//
//  InformationPlaceTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 27/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "NombreCell.h"
#import "DescripcionCell.h"
#import "DireccionCell.h"
#import "HoraCell.h"
#import "AdicionalInformacionCell.h"
#import "InformationPlaceTableViewController.h"

@interface InformationPlaceTableViewController (){

    NSArray *rowInSectionArray1;
    //NSArray *rowInSectionArray2;
}

@end

@implementation InformationPlaceTableViewController



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
    
    //instanciando sectionArray para las secciones
    
    rowInSectionArray1=[[NSMutableArray alloc] init];
    //rowInSectionArray2=[[NSMutableArray alloc] initWithObjects:@"sdfdf", nil];
    
    NSString *cod = self.ObjetoA.objectId;
    NSLog(@"el id es: %@",cod);
    
    NSString *nom=self.ObjetoA[@"name"];
    
    self.navigationItem.title = nom;
    //Query
    PFQuery *query = [PFQuery queryWithClassName:@"Hora"];
    [query whereKey:@"objectId" equalTo:cod];

    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"entra al query de hola!!!!!!! ehhhhhhhhhhh");
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            
            
            rowInSectionArray1 = objects;
            //actualizar tabla con datos
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == 0){
         return title=@"Información";
    }
    else if (section == 1){
         return title=@"Horas";
    }
    /*else if (section == 2){
        return title=@"Contactos";
    }*/
    return title;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3; //However many static cells you want
    } else if(section==1) {
        return [rowInSectionArray1 count];
    }
   /* else if(section==2) {
        return [rowInSectionArray2 count];
    }*/
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(indexPath.row==0){
            
            NombreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nombreCell"];
            if(cell == nil){
                cell = [NombreCell nombreCell];
                cell.titleLabel.text=self.ObjetoA[@"name"];
                 NSLog(@"entra........0");
            }
            return cell;
           }
        else if(indexPath.row==1){
            
            DescripcionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descripcionCell"];
            if(cell == nil){
                cell = [DescripcionCell descripcionCell];
                cell.descriptionLabel.text=self.ObjetoA[@"introduction"];
            }
            return cell;
        }
        else if(indexPath.row==2){
            
            DireccionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"direccionCell"];
            if(cell == nil){
                cell = [DireccionCell direccionCell];
                cell.directionLabel.text=self.ObjetoA[@"address"];
                NSLog(@"entra........2");
            }
            return cell;
        }

        
    } else if (indexPath.section == 1){
         NSLog(@"estaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        HoraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"horaCell"];
        
        if (cell == nil) {
            NSLog(@"estaaccccccccccccccccccccccccccccccc");
            cell = [HoraCell horaCell];
            PFObject *horaDetail=[rowInSectionArray1 objectAtIndex:indexPath.row];
            // Configure the cell...
             UILabel * diaLabel = (UILabel *)[cell viewWithTag:1];
             UILabel * horaLabel = (UILabel *)[cell viewWithTag:2];
             UILabel * horaCerradoLabel = (UILabel *)[cell viewWithTag:3];
            
            diaLabel.text=horaDetail[@"dia"];
            horaLabel.text=horaDetail[@"hora"];
            horaCerradoLabel.text=horaDetail[@"horaCerrado"];
           
            cell.diaLabel.text =horaDetail[@"dia"];
            NSLog(@"esta es la hora detail: ......%@",horaDetail);
            cell.horaLabel.text = horaDetail[@"hora"];
            cell.horaCerradoLabel.text=horaDetail[@"horaCerrado"];
        }
        return cell;
        NSLog(@"esteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
        
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
       if (indexPath.row == 0) {
            return 44;
        } else if(indexPath.row==1){
            return 88;
        } else if(indexPath.row==2){
            return 66;
        }
        return 44;
    }
    else if(indexPath.section==1){
        return 44;
    }
    /*else if(indexPath.section==2){
        return 44;
    }*/
    return 44.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    } else if (section == 1) {
        return @"Este es un footer";
    } /*else if (section == 2) {
                return @"este es otro footer mucho mas largo para este ejemplo";
    }*/
    return nil;
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

    @end
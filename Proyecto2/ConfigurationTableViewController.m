//
//  ConfigurationTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 23/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "ConfigurationTableViewController.h"

@interface ConfigurationTableViewController ()
{
    NSArray* perfilArray;
    NSArray* InformacionArray;
}
@end

@implementation ConfigurationTableViewController

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
    
    perfilArray=[[NSArray alloc]initWithObjects:@"Perfíl",@"Cerrar Seción", nil];
    InformacionArray=[[NSArray alloc] initWithObjects:@"Acerca de La Paz",@"Desarrollador",@"Condiciones de Servicio y Privacidad", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return [perfilArray count];
    }
    if (section==1) {
        return [InformacionArray count];
    }
    
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        UILabel * Label = (UILabel *)[cell viewWithTag:1];
        Label.text=[perfilArray objectAtIndex:indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        UILabel * Label = (UILabel *)[cell viewWithTag:1];
        Label.text=[InformacionArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    if(indexPath.section == 0){
        if (indexPath.row==0) {
            PerfilConfigurationViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"perfilConfigurationViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if (indexPath.row==1) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Esta seguro que desea salir de La Paz?" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];
            [PFUser logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
            /*LoginViewController *loginController=[[UIStoryboard storyboardWithName:@"loginViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"]; //or the homeController
            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
            self.window.rootViewController=navController;*/
        }
    }
    if(indexPath.section == 1){
        if (indexPath.row==0) {
            AcercaDeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"acercaDeViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if (indexPath.row==1) {
            ApoyoViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"apoyoViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if (indexPath.row==2) {
            SeguridadPrivacidadViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"seguridadPrivacidadViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"General";
    }
    if (section==1) {
        return @"Más";
    }
    return @"";
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

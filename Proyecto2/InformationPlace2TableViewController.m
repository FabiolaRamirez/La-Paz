//
//  InformationPlace2TableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 01/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "NombreCell.h"
#import "DescripcionCell.h"
#import "DireccionCell.h"
#import "InformationPlace2TableViewController.h"

@interface InformationPlace2TableViewController ()
{
    
}
@end

@implementation InformationPlace2TableViewController

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

    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Información";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        NombreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"nombreCell"];
        if (cell==nil) {
            cell=[NombreCell nombreCell];
            
            cell.titleLabel.text= self.ObjetoB[@"name"];
            
        }
        return cell;
        
    }
    else if (indexPath.row==1){
        DescripcionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"descripcionCell"];
        if (cell==nil) {
            cell=[DescripcionCell descripcionCell];
            
            cell.descriptionLabel.text= self.ObjetoB[@"introduction"];
            NSString* var=self.ObjetoB[@"introduction"];
            NSLog(@"wwwwwwwwwwwwwwwww:%@",var);
           
        }
        return cell;
    }
    else if (indexPath.row==2){
        DireccionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"direccionCell"];
        if (cell==nil) {
            cell=[DireccionCell direccionCell];
            cell.directionLabel.text= self.ObjetoB[@"address"];
        }
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       if(indexPath.row==0){
        return 44;
    } else if(indexPath.row==1){
        return 88;
    } else if(indexPath.row==2){
        return 44;
    }
    
    return 44.0f; //cell for comments, in reality the height has to be adjustable
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

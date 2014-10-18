//
//  SearchTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "SearchTableViewController.h"
#import <Parse/Parse.h>

@interface SearchTableViewController () <UISearchBarDelegate> {
        NSArray * places;
}

@end

@implementation SearchTableViewController

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
    
    
    places = [[NSArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    //    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buscarCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *textoLabel = (UILabel *)[cell viewWithTag:1];
    
    PFObject *placeDetail=[places objectAtIndex:indexPath.row];
    
    textoLabel.text = placeDetail[@"name"];
    
    return cell;
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


// este es el metodo que se ejecuta cuando buscas

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *query = searchBar.text;
    NSLog(@"search... |%@|", query);
    
    [self buscarLugaresEnParse:query];
    
}


- (void) buscarLugaresEnParse: (NSString *) consulta {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"name" equalTo:consulta];
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


@end

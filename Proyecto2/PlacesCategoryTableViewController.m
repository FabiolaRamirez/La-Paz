//
//  PlacesCategoryTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 07/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PlacesCategoryTableViewController.h"
#import "PlacesTableViewController.h"
#import "MapDetailPlaceViewController.h"
@interface PlacesCategoryTableViewController (){

    NSArray * categorias;
    UIRefreshControl *refreshControl;

    
}
@end

@implementation PlacesCategoryTableViewController

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
   
    
    categorias = [[NSMutableArray alloc] init];
    
    NSString *nom = self.seccionObject[@"name"];
    self.navigationItem.title = nom;
    
    [self getPlacesFromParse];
    
    //inicializando el icono de carga
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configRefreshControl];
    NSLog(@"entra __________***********");
    
}

-(void) getPlacesFromParse{
    //Query
    NSString *cate = self.seccionObject[@"code"];
    NSLog(@".......:::%@",cate);
    PFQuery *query = [PFQuery queryWithClassName:@"Categoria"];
    [query whereKey:@"code1" equalTo:cate];
    
    //[query orderByAscending:@"Tipo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            categorias = objects;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [categorias count];

}

// sirve para decir que mostrar en la celda indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriaCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel * nombreLabel = (UILabel *)[cell viewWithTag:2];
    UIImageView * fotoImageView = (UIImageView *)[cell viewWithTag:1];
    
    PFObject *categoria = [categorias objectAtIndex:indexPath.row];
    
    nombreLabel.text = categoria[@"name"];
    
    //para obtener imagen
    PFFile *imageFile=[categoria objectForKey:@"imageFile"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
     if(!error){
     fotoImageView.image=[UIImage imageWithData:data];
     NSLog(@"entra!!");
     }
     else{
     NSLog(@"Error: %@ %@", error, [error userInfo]);
     }
     
     }];
    //[fotoImageView setImageWithURL:[NSURL URLWithString:categoria[@"urlImage"]]
    //            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;

    
}



// darle accion a la celda indexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    PFObject *categoria = [categorias objectAtIndex:indexPath.row];
    
    // push para continuar
    PlacesTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placesTableViewController"];
    tableViewController.categoriaObject = categoria;
    
    [self.navigationController pushViewController:tableViewController animated:YES];
    // modal es para salir de contexto
    
     /*UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placeViewController"];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

-(void) configRefreshControl{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
}

- (void) updateData: (id) sender {
    NSLog(@"se ejecuta cuando se suelta con el dedo el refresh");
    
    [self getPlacesFromParse];
}

@end

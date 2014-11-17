//
//  PeopleTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 17/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PeopleTableViewController.h"

@interface PeopleTableViewController ()
{
    NSArray * personasVector;
     UIRefreshControl *refreshControl;
}

@end

@implementation PeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    personasVector=[[NSArray alloc] init];
    
   [self configRefreshControl];
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"se ejecuta cada rato");
    
     [self getRankingFromParse];
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

    return [personasVector count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel * countConquerLabel = (UILabel *)[cell viewWithTag:3];
    UILabel * CountMedallLabel = (UILabel *)[cell viewWithTag:4];
    UIImageView * UserImageView = (UIImageView *)[cell viewWithTag:2];
    
    
    PFObject *object = [personasVector objectAtIndex:indexPath.row];
    
    nameLabel.text = object[@"username"];
    if (object[@"ranking"]!=nil) {
        countConquerLabel.text=[NSString stringWithFormat:@"%@ conquistas",object[@"ranking"]];
    }
    else{
        countConquerLabel.text=@"0";
    }
    //para obtener imagen
    PFFile *imageFile=[object objectForKey:@"imageUser"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            UserImageView.layer.masksToBounds=YES;
            UserImageView.layer.cornerRadius=22;
            UserImageView.image=[UIImage imageWithData:data];
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

- (void) getRankingFromParse {
    NSLog(@"getRankingFromParse");
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"ranking"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refreshControl endRefreshing];
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            personasVector = objects;
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
    
    [self getRankingFromParse];
}


@end

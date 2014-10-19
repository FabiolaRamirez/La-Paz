//
//  SectionPlaceCollectionViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 16/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "SectionPlaceCollectionViewController.h"
#import "SectionPlaceCollectionViewCell.h"
#import "PlacesCategoryTableViewController.h"
#import <Parse/Parse.h>

@interface SectionPlaceCollectionViewController ()
{
    NSArray * itemArray;
}

@end

@implementation SectionPlaceCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    itemArray = [[NSMutableArray alloc] init];
    //Query
    PFQuery *query = [PFQuery queryWithClassName:@"SectionPlace"];
    [query orderByAscending:@"name"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %i scores.", (int)objects.count);
            
            itemArray = objects;
            //actualizar tabla con datos
            [self.collectionView reloadData];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [itemArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SectionPlaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"sectionPlaceCollectionViewCell" forIndexPath:indexPath];
    //config mi cell
    UIImageView * fotoImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel * nombreLabel = (UILabel *)[cell viewWithTag:2];
    
    
    PFObject *sectionPlace = [itemArray objectAtIndex:indexPath.row];
    
    nombreLabel.text = sectionPlace[@"name"];
    
    //para obtener imagen
   PFFile *imageFile=[sectionPlace objectForKey:@"imageFile"];
    
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
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"SE PRESIONO %i", (int)indexPath.row);
    
    PFObject *sectionPlace = [itemArray objectAtIndex:indexPath.row];
    
    // push para continuar
    PlacesCategoryTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"placesCategoryTableViewController"];
    tableViewController.ObjetoC=sectionPlace;
    
    [self.navigationController pushViewController:tableViewController animated:YES];

}
- (IBAction)goRanking:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end

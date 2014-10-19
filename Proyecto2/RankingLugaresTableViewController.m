//
//  RankingLugaresTableViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "RankingLugaresTableViewController.h"
#import "SectionPlaceCollectionViewController.h"
@implementation RankingLugaresTableViewController

- (IBAction)goCategories:(UIBarButtonItem *)sender {
    
    SectionPlaceCollectionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sectionPlaceCollectionViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return nil;
}
@end

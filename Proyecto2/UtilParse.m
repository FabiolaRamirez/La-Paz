//
//  UtilParse.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 11/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "UtilParse.h"


@implementation UtilParse



+ (NSArray *) getConquistasToCurrentUser {
    NSLog(@"Start getConquistasToCurrentUser.");
    __block NSArray *placesArray = [[NSArray alloc] init];
    
    NSMutableArray *codigosLugaresArray = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) { // si existe el usuario
        
        PFQuery *query = [PFQuery queryWithClassName:@"Conquista"];
        [query whereKey:@"codigo_user" equalTo:currentUser.objectId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Successfully retrieved %i scores. (getConquistasToCurrentUser)", (int)objects.count);
                
                NSArray *conquistasArray = objects;
                for (PFObject *conquista in conquistasArray) {
                    [codigosLugaresArray addObject:conquista[@"codigo_place"]];
                }
                
                placesArray = [UtilParse getPlacesFromTheirCodes: codigosLugaresArray];
                
            } else {
                NSLog(@"Error (getConquistasToCurrentUser): %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        NSLog(@"Error raro no hay usuario. (getConquistasToCurrentUser)");
    }
    NSLog(@"numero de lugares %i (getConquistasToCurrentUser)", (int)[placesArray count]);
    return placesArray;
}

+ (NSArray *) getPlacesFromTheirCodes: (NSArray *) codesArray {
    NSLog(@"Start getPlacesFromTheirCodes.");
    
    __block NSArray *placesArray = [[NSArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"objectId" containedIn:codesArray];
    [query orderByAscending:@"name"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %i scores. (getPlacesFromTheirCodes)", (int)objects.count);
            placesArray = objects;
        } else {
            NSLog(@"Error (getPlacesFromTheirCodes): %@ %@", error, [error userInfo]);
        }
    }];
    NSLog(@"numero de lugares %i (getPlacesFromTheirCodes)", (int)[placesArray count]);
    return placesArray;
}




@end

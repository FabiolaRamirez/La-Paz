//
//  UtilParse.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 11/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilParse : NSObject

+ (NSArray *) getConquistasToCurrentUser;
+ (NSArray *) getPlacesFromTheirCodes: (NSArray *) codesArray;

@end

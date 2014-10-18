//
//  Util.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)number2Decimals:(double)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,###,##0.00"];
    [numberFormatter setNegativeFormat:@"(###,###,###,###,##0.00)"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}


@end

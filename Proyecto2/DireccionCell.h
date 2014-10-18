//
//  DireccionCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 31/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DireccionCell : UITableViewCell
+ (DireccionCell*) direccionCell;

@property (strong, nonatomic) IBOutlet UILabel *directionLabel;

@end

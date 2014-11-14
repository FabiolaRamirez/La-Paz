//
//  ConquerCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 23/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConquerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *directionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *placeImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

+ (ConquerCell*) conquerCell;
@end

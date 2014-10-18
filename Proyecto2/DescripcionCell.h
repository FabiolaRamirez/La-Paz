//
//  DescripcionCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 31/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescripcionCell : UITableViewCell
+ (DescripcionCell*) descripcionCell;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

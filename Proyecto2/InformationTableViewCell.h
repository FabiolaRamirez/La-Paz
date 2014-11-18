//
//  InformationTableViewCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
+ (InformationTableViewCell*) informationTableViewCell;

@end

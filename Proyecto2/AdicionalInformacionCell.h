//
//  AdicionalInformacionCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 31/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdicionalInformacionCell : UITableViewCell
+ (AdicionalInformacionCell*) adicionalInformacionCell;
@property (strong, nonatomic) IBOutlet UILabel *nombreLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

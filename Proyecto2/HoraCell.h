//
//  HoraCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 31/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoraCell : UITableViewCell
+ (HoraCell*) horaCell;
@property (strong, nonatomic) IBOutlet UILabel *diaLabel;
@property (strong, nonatomic) IBOutlet UILabel *horaLabel;
@property (strong, nonatomic) IBOutlet UILabel *horaCerradoLabel;


@end

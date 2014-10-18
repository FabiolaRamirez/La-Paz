//
//  MedalCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 24/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedalCell : UITableViewCell

+ (MedalCell*) medalCell;

/*
- (IBAction)recompensaButton:(UIButton *)sender;

- (IBAction)medalleroButton:(UIButton *)sender;
*/
@property (strong, nonatomic) IBOutlet UILabel *contadorReconpensaLabel;

@property (strong, nonatomic) IBOutlet UILabel *contadorMedalleroLabel;
@property (strong, nonatomic) IBOutlet UIButton *recompensasButton;
@property (strong, nonatomic) IBOutlet UIButton *medalleroButton;

@end

//
//  PerfilCell.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 24/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilCell : UITableViewCell
+ (PerfilCell*) perfilCell;
@property (strong, nonatomic) IBOutlet UILabel *tituloLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

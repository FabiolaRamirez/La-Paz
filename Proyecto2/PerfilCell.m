//
//  PerfilCell.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 24/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PerfilCell.h"

@implementation PerfilCell
@synthesize tituloLabel,userImageView,usernameLabel,descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (PerfilCell*) perfilCell
{
    PerfilCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PerfilCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

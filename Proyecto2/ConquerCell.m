//
//  ConquerCell.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 23/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "ConquerCell.h"

@implementation ConquerCell
@synthesize titleLabel,directionLabel,placeImageView;

+ (ConquerCell*) conquerCell
{
    ConquerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ConquerCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

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

@end

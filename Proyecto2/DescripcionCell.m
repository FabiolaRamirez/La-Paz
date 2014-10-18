//
//  DescripcionCell.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 31/08/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "DescripcionCell.h"

@implementation DescripcionCell
@synthesize descriptionLabel;


+ (DescripcionCell*) descripcionCell
{
    DescripcionCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DescripcionCell" owner:self options:nil] objectAtIndex:0];
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

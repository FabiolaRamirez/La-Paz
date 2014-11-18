//
//  InformationTableViewCell.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell
@synthesize nameLabel,informationLabel;

+ (InformationTableViewCell*) informationTableViewCell
{
    InformationTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end

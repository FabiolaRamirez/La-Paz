//
//  MedalCell.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 24/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "MedalCell.h"
#import "MedalTableViewController.h"
@implementation MedalCell

@synthesize contadorMedalleroLabel,contadorReconpensaLabel;

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
    
    [self.recompensasButton addTarget:self
                 action:@selector(irRecompensas)
       forControlEvents:UIControlEventTouchUpInside];
}

- (void) irRecompensas {
    NSLog(@"irRecompensas");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (MedalCell*) medalCell
{
    MedalCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MedalCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
- (IBAction)recompensaButton:(UIButton *)sender {
    
}

- (IBAction)medalleroButton:(UIButton *)sender {
    MedalTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"medalTableViewController"];
   
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}
*/
@end

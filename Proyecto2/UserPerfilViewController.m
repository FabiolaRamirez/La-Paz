//
//  UserPerfilViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 14/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "UserPerfilViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>

#import "ConfigurationTableViewController.h"

@interface UserPerfilViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *UserImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *contadorLabel;
- (IBAction)configurationButton:(UIBarButtonItem *)sender;


@end

@implementation UserPerfilViewController{
    NSMutableArray * vector;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vector=[[NSMutableArray alloc] init];
    [vector addObject:@"hello"];
    [vector addObject:@"heleee"];
    [vector addObject:@"hetttt"];
    [vector addObject:@"heooooo"];
    
    //para redondear imagen de perfil
    _UserImageView.clipsToBounds = YES;
    [self setRoundedView:_UserImageView toDiameter:60.0];
    
    // call api facebook
    [FBRequestConnection startWithGraphPath:@"me?fields=id,name,about,cover,gender"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@">: %@", result);
                                  
                                  [self parseJSON:result];
                                  
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//metodo redondear imagen del perfil de usuario
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}


-(void)parseJSON: (id) json {
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *deserializedDictionary = (NSDictionary *)json;
        
        NSString *nombre = [deserializedDictionary objectForKey:@"name"];
        NSLog(@":::::: %@", nombre);
        self.usernameLabel.text=nombre;
        
        NSDictionary *cover = [deserializedDictionary objectForKey:@"cover"];
        NSString *source = [cover objectForKey:@"source"];
        NSLog(@":::::: %@", source);
        
    }
}


- (IBAction)configurationButton:(UIBarButtonItem *)sender {
    ConfigurationTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"configurationTableViewController"];
    
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}
#pragma Collection View Methods 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [vector count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel * titlelabel=(UILabel *)[cell viewWithTag:1];
    UIImageView *imageview=(UIImageView *)[cell viewWithTag:2];
    
    titlelabel.text=@"titulo";
    //imageview.image=
    
    return cell;
}
@end

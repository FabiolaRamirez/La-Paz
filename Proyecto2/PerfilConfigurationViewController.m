//
//  PerfilConfigurationViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 15/11/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "PerfilConfigurationViewController.h"
@interface PerfilConfigurationViewController (){
    PFUser *user;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *biografiaTextField;

@end
@implementation PerfilConfigurationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCurrentUser];
    
}


-(void)setCurrentUser{
    user = [PFUser currentUser];
    if (user) {
        
        _nameTextField.placeholder =user.username;
        //_nameTextField.textColor = [UIColor primaryDarkColor];
        _emailTextField.text=user[@"email"];
        _biografiaTextField.text=user[@"description"];
        //pa inagen de usuario
        PFFile *imageFile=[user objectForKey:@"imageUser"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error){
                _imageUser.layer.masksToBounds=YES;
                _imageUser.layer.cornerRadius=30;
                
                _imageUser.image=[UIImage imageWithData:data];
                NSLog(@"entra!!");
            }
            else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
    } else {
        
        
        NSLog(@"No hay usuario error raro");
    }
}

- (IBAction)guardarButton:(UIBarButtonItem *)sender {
    
    NSString *name = _nameTextField.text;
     NSString *email = _emailTextField.text;
     NSString *biografia = _biografiaTextField.text;
  
    user = [PFUser currentUser];
    if (user) {
        user.username=name;
        user.email=email;
        user[@"description"]=biografia;
        user[@"imageUser"]=_imageUser;
        [user saveInBackground];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Guardado" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    } else {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Revise su conexión" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        NSLog(@"No sepudo cargar los datos del user actual");
    }
}
- (IBAction)editarFotoButton:(UIButton *)sender {
    
    }

@end

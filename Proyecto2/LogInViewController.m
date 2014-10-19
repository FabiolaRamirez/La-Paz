//
//  LogInViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 02/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "UIColor+LaPaz.h"
//#import <ParseFacebookUtils/ParseFacebookUtils.h>
@interface LogInViewController () <UITextFieldDelegate> {
    JGProgressHUD *HUD;
}


@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIView *fontStoryboardView;

@end

@implementation LogInViewController
UIGestureRecognizer *tapper;

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
    
    //metodo para ocultar teclado haciendo click fuera del textField
    [self hideKeyboard];
    //metodo retornar accion del teclado "aceptar"
    [self ActionButtonKeyboardUserTextField];
    [self ActionButtonKeyboardPasswordTextField];
    //[_logInButton setBackgroundColor:[UIColor primaryLightColor]];
    [_fontStoryboardView setBackgroundColor:[UIColor primaryColor]];
    //ocultar navigation bar
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Ingresando...";
    
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

#pragma mark - Login
- (IBAction)login:(UIButton *)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    
    NSString * usename=self.usernameTextField.text;
    NSString * password=self.passwordTextField.text;
    
    if (usename.length>0&&password.length>0) {
        
        [HUD showInView:self.view];
        
        
        NSLog(@"ok");
        //Por if true verifica por correo de usuario
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:usename];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            
            if (!error) {
                
                if (objects.count > 0) {
                    
                    PFObject *object = [objects objectAtIndex:0];
                    NSString *username = [object objectForKey:@"username"];
                    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser* user, NSError* error){
                        
                        
                        [HUD dismissAnimated:YES];
                        
                        if (user) {
                            // Do stuff after successful login.
                            NSLog(@"login ok!");
                            
                            // nos lleva a la vista modal
                            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarController"];
                            
                            // si queremos que tenga naigation bar
                            // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                            
                            [self presentViewController:viewController animated:YES completion:nil];
                            
                            
                        } else {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Correo electronico o contraseña incorrecto" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                    
                }else{
                    //por else verifica por nombre de usuario
                    [PFUser logInWithUsernameInBackground: usename password:password block:^(PFUser* user, NSError* error){
                        
                        [HUD dismissAnimated:YES];
                        
                        
                        if (user) {
                            // Do stuff after successful login.
                            NSLog(@"login ok!");
                            
                            
                            // modal
                            
                            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarController"];
                            
                            // si queremos que tenga naigation bar
                            // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                            
                            [self presentViewController:viewController animated:YES completion:nil];
                            
                            
                        } else {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Correo electronico o contraseña incorrecto" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                            [alert show];
                        }
                        
                    }];
                    
                }
                
            } else {
                NSLog(@"NO HAY INTERNET");
                [HUD dismissAnimated:YES];
                
                [self showErrorHUD];
            }
            
        }];
        
        
        
        
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Complete los espacios vacios" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        
    }
    
}


#pragma mark - Login con facebook
- (IBAction)loginWithFacebook:(UIButton *)sender {
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
    [HUD showInView:self.view];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [HUD dismissAnimated:YES];
        if (user) {
            
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                if (![PFFacebookUtils isLinkedWithUser:user]) {
                    [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Woohoo, user logged in with Facebook!");
                        }
                    }];
                }
            } else {
                NSLog(@"User with facebook logged in!");
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarController"];
                
                [self presentViewController:viewController animated:YES completion:nil];
                
            }
            
        }
        else {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login!!!!.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }];
    
    
}
//metodo dar accion al boton aceptar del teclado

-(void)ActionButtonKeyboardUserTextField{
    [self.usernameTextField setDelegate:self];
    [self.usernameTextField setReturnKeyType:UIReturnKeyDone];
    [self.usernameTextField addTarget:self
                               action:@selector(login:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
-(void)ActionButtonKeyboardPasswordTextField{
    [self.passwordTextField setDelegate:self];
    [self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    [self.passwordTextField addTarget:self
                               action:@selector(login:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
//********
//metodo para ocultar teclado haciendo click fuera del textField
-(void)hideKeyboard{
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];}
//metodo ocultar teclado click fuera de textField
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}





- (void)showErrorHUD {
    JGProgressHUD *HUD2 = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];

    HUD2.textLabel.text = @"Error!";
    HUD2.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD2.square = YES;
    
    [HUD2 showInView:self.navigationController.view];

    [HUD2 dismissAfterDelay:2.0];
}



- (void)showSuccessHUD {
JGProgressHUD *HUD3 = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    
    HUD.textLabel.text = @"Success!";
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:3.0];
}


@end

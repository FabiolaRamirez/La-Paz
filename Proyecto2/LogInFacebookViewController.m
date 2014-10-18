//
//  LogInFacebookViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 04/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "LogInFacebookViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface LogInFacebookViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;




- (IBAction)loginButtonTouchHandler:(UIButton *)sender;


@end

@implementation LogInFacebookViewController

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
    // Do any additional setup after loading the view.
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

- (IBAction)loginButtonTouchHandler:(UIButton *)sender {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    
    NSString * usename=self.usernameTextField.text;
    NSString * password=self.passwordTextField.text;
    
    if (usename.length>0&&password.length>0) {
        NSLog(@"ok");
        NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
        
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            
            if (user) {
                
                //[self _presentUserDetailsViewControllerAnimated:YES];
                
            } else {
                NSString *errorMessage = nil;
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                    errorMessage = @"Uh oh. The user cancelled the Facebook login.";
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                    errorMessage = [error localizedDescription];
                }
                if (user.isNew) {
                    NSLog(@"User with facebook signed up and logged in!");
                } else {
                    NSLog(@"User with facebook logged in!");
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
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Complete los espacios vacios" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
}
@end

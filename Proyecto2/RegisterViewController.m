//
//  RegisterViewController.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 02/09/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordTextField;


@end

@implementation RegisterViewController
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
     [self ActionButtonKeyboardEmailTextField];
     [self ActionButtonKeyboardPasswordTextField];
     [self ActionButtonKeyboardRepeatPasswordTextField];
    
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
- (IBAction)register:(UIBarButtonItem *)sender {
    NSLog(@"hola");
    
    NSString *username = self.userTextField.text;
    NSString *email=self.emailTextField.text;
    NSString *password=self.passwordTextField.text;
    NSString *repeatPassword=self.repeatPasswordTextField.text;
    
    if (username.length>0 && email.length>0&& password.length>0&&repeatPassword.length>0) {
       if([self validateEmail:email]) {
        // registrar
           if(password.length>5 || repeatPassword.length>5){
        if([password isEqualToString:repeatPassword]){
          NSLog(@"ok!");
            
            
            PFUser *user = [PFUser user];
            user.username = username;
            user.password = repeatPassword;
            user.email = email;
            
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // Hooray! Let them use the app now.
                    
                    NSLog(@"todo salio bien");
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Su registro fue exitoso" message:nil delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    NSString * errorCode = [error userInfo][@"code"];
                    errorCode = [NSString stringWithFormat:@"%@", errorCode];
                    
                    NSLog(@"%@", errorCode);
                    
                    if([errorCode isEqualToString:@"202"]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"El usuario ya existe" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                        self.userTextField.text=@"";
                    }
                    if([errorCode isEqualToString:@"203"]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ya existe una cuenta con este correo" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                        [alert show];
                        self.emailTextField.text=@"";
                    }
                    
                }
            }];
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Las contraseñas no son iguales" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];
            
            self.passwordTextField.text = @"";
            self.repeatPasswordTextField.text = @"";
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"La contraseña es demaciado corta" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
           
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"El correo electrónico que ingresaste no parece pertenecer a una cuenta. Verifica tu dirección de correo y vuelve a intentarlo." message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        
    }
    
    }
      else {
        // mostrar mensaje
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Por favor" message:@"Llene los espacios vacios." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];

        
      }
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

//metodo dar accion al boton aceptar del teclado

-(void)ActionButtonKeyboardUserTextField{
    [self.userTextField setDelegate:self];
    [self.userTextField setReturnKeyType:UIReturnKeyDone];
    [self.userTextField addTarget:self
                           action:@selector(register:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
-(void)ActionButtonKeyboardEmailTextField{
    [self.emailTextField setDelegate:self];
    [self.emailTextField setReturnKeyType:UIReturnKeyDone];
    [self.emailTextField addTarget:self
                           action:@selector(register:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
-(void)ActionButtonKeyboardPasswordTextField{
    [self.passwordTextField setDelegate:self];
    [self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    [self.passwordTextField addTarget:self
                           action:@selector(register:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
-(void) ActionButtonKeyboardRepeatPasswordTextField{
    [self.repeatPasswordTextField setDelegate:self];
    [self.repeatPasswordTextField setReturnKeyType:UIReturnKeyDone];
    [self.repeatPasswordTextField addTarget:self
                           action:@selector(register:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}
//*****************

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



@end

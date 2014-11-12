//
//  Util.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "Util.h"

@implementation Util

JGProgressHUD *HUD;

+ (NSString *)number2Decimals:(double)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,###,##0.00"];
    [numberFormatter setNegativeFormat:@"(###,###,###,###,##0.00)"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}




#pragma mark - Messages

+ (void) showProgress: (UIView *)view {
    HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    //    HUD.textLabel.text = @"Ingresando...";
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [HUD showInView:view];
}

+ (void) hideProgress: (UIView *) view {
    if ([HUD isVisible]) {
        [HUD dismiss];
    }
}

+ (void) showMessage: (NSString *) message view:(UIView *) view {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = nil;
    HUD.textLabel.text = message;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;

    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    [HUD showInView:view];
    [HUD dismissAfterDelay:2.0];
}

+ (void) showSuccess: (NSString *) message view:(UIView *) view {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    HUD.textLabel.text = message;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    [HUD showInView:view];
    [HUD dismissAfterDelay:2.0];
    
}

+ (void) showError: (NSString *) message view:(UIView *) view {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.textLabel.text = message;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;

    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    [HUD showInView:view];
    [HUD dismissAfterDelay:2.0];

}

+ (void) showImportantMessage: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void) showImportantMessage:(NSString *)title message:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void) showConnectionError: (UIView *) view {
    [Util showError:NSLocalizedString(@"Error de conexión, intente de nuevo por favor", nil) view:view];
}


+ (void) showUnexpectedError: (UIView *) view {
    [Util showError:NSLocalizedString(@"Error de inesperado, intente ingresar de nuevo", nil) view:view];
}

@end

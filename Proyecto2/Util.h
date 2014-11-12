//
//  Util.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 18/10/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGProgressHUD.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface Util : NSObject

+ (NSString *)number2Decimals:(double)number;

#pragma mark - Messages

+ (void) showProgress: (UIView *)view;

+ (void) hideProgress: (UIView *) view;

+ (void) showMessage: (NSString *) message view:(UIView *) view;
+ (void) showSuccess: (NSString *) message view:(UIView *) view;
+ (void) showError: (NSString *) message view:(UIView *) view;

+ (void) showImportantMessage:(NSString *)title message:(NSString *) message;
+ (void) showImportantMessage: (NSString *) message;

+ (void) showConnectionError: (UIView *) view;
+ (void) showUnexpectedError: (UIView *) view;


@end

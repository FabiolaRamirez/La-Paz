//
//  Annotation.h
//  Proyecto2
//
//  Created by Fabiola Ramirez on 08/07/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface Annotation : NSObject   <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

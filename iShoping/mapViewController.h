//
//  mapViewController.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-29.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface mapViewController : UIViewController<MKMapView>
@property (retain, nonatomic)MKMapView *mapView;
@property (retain, nonatomic)UIActivityIndicatorView *activity;
@end

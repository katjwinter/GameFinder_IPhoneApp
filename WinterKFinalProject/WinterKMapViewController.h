//
//  WinterKMapViewController.h
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/31/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WinterKSharedDataModel;

@interface WinterKMapViewController : UIViewController
@property WinterKSharedDataModel *dataModel;
- (void)drawLocations;

@end

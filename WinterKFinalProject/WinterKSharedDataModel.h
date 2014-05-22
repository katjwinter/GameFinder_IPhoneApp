//
//  WinterKSharedDataModel.h
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/31/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SMXMLDocument.h"

@interface WinterKSharedDataModel : NSObject {
    SMXMLElement *locationsRoot;
    CLLocation *userLocation;
    Boolean bManual;
    Boolean bGameStop;
    Boolean bBestBuy;
    NSString *manualZip;
}

+ (id) sharedData;

@property (nonatomic, retain) SMXMLElement *locationRoot;
@property (nonatomic, retain) CLLocation *userLocation;
@property Boolean bManual;
@property Boolean bGameStop;
@property Boolean bBestBuy;
@property (nonatomic, retain) NSString *manualZip;


@end

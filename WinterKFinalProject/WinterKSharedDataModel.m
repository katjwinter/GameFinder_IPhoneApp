//
//  WinterKSharedDataModel.m
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/31/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import "WinterKSharedDataModel.h"

@implementation WinterKSharedDataModel

@synthesize locationRoot;
@synthesize userLocation;
@synthesize bManual;
@synthesize bGameStop;
@synthesize bBestBuy;
@synthesize manualZip;

WinterKSharedDataModel *sharedDataModel = nil;

+ (id)sharedData {
    @synchronized(self) {
        
        if (sharedDataModel == nil) {
            sharedDataModel = [[self alloc] init];
            sharedDataModel.locationRoot = nil;
            sharedDataModel.userLocation = nil;
            sharedDataModel.bManual = false;
            sharedDataModel.bGameStop = true;
            sharedDataModel.bBestBuy = true;
            sharedDataModel.manualZip = nil;
        }
        return sharedDataModel;
    }
}
@end

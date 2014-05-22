//
//  WinterKMapViewController.m
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/31/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import "WinterKMapViewController.h"
#import "WinterKSharedDataModel.h"
#import <GoogleMaps/GoogleMaps.h>

@interface WinterKMapViewController ()

@end

@implementation WinterKMapViewController {
    GMSMapView *mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"103-map"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataModel = [WinterKSharedDataModel sharedData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLLocation *userLocation = _dataModel.userLocation;
    CLLocationCoordinate2D coordinates = userLocation.coordinate;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                            longitude:coordinates.longitude
                                                                 zoom:10];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.position = coordinates;
    marker.title = @"Starting Location";
    marker.animated = YES;
    marker.map = mapView;
    
    if (_dataModel.locationRoot != nil) {
        [self drawLocations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLocations {

    SMXMLElement *rootElem = _dataModel.locationRoot;
    for (SMXMLElement *location in rootElem.children) {
        NSString *strLat = [location valueWithPath:@"lat"];
        NSString *strLong = [location valueWithPath:@"long"];
        
        GMSMarker *storeMarker = [[GMSMarker alloc] init];
        storeMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        storeMarker.animated = YES;
        float fLat = [strLat floatValue];
        float fLong = [strLong floatValue];
        storeMarker.position = CLLocationCoordinate2DMake(fLat, fLong);
        NSString *titleInfo = [NSString stringWithFormat:
                               @"%@ - %@", [location valueWithPath:@"store"], [location valueWithPath:@"price"]];
        storeMarker.title = titleInfo;
        NSString *storeInfo = [NSString stringWithFormat:
                               @"%@\n%@\n%@,%@ %@\n%@", [location valueWithPath:@"name"], [location valueWithPath:@"address1"],
                               [location valueWithPath:@"city"], [location valueWithPath:@"state"],
                               [location valueWithPath:@"zip"], [location valueWithPath:@"phone"]];
        storeMarker.snippet = storeInfo;
        storeMarker.map = mapView;
    }
}

@end

//
//  WinterKFirstViewController.h
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/25/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMXMLDocument.h"

@class WinterKSharedDataModel;

@interface WinterKFirstViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, NSURLConnectionDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *titleChoicePicker;
- (IBAction)onTitleChoiceCancel:(UIBarButtonItem *)sender;
- (IBAction)onTitleChoiceDone:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *titleChoiceBar;
@property (weak, nonatomic) IBOutlet UIView *titleChoiceView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchIndicatorText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchIndicator;
- (IBAction)onTitleDone:(UITextField *)sender;
- (IBAction)onTitleFieldTouch:(UITextField *)sender;
- (IBAction)onSearch:(UIButton *)sender;
- (IBAction)onSystemSelect:(UITextField *)sender;
- (void)onSystemPickerDone:(UIBarButtonItem *)sender;
- (void)onTitleClear:(UIBarButtonItem *)sender;
- (void)initiateSearch;
- (void)adjustAlphas:(float)alphaAmount;
- (void)showTitleOptions:(SMXMLElement *)rootElem;
- (void)locateGame;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *systemField;
@property (nonatomic, retain) NSMutableArray *systemArray;
@property (nonatomic, retain) NSMutableArray *titleArray;
@property NSString *gameTitle;
@property NSString *encodedGameTitle;
@property NSString *gameSystem;
@property NSMutableData *responseData;
@property CLLocationManager *locationManager;
@property NSString *zipCode;
@property WinterKSharedDataModel *dataModel;

@end

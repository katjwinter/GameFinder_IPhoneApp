//
//  WinterKSecondViewController.h
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/25/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinterKSharedDataModel.h"

@interface WinterKSecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *zipSlider;
@property (weak, nonatomic) IBOutlet UISwitch *bestbuySlider;
@property (weak, nonatomic) IBOutlet UISwitch *gamestopSlider;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property WinterKSharedDataModel *dataModel;
- (IBAction)manualZipChanged:(UISwitch *)sender;
- (IBAction)onApply:(UIButton *)sender;
- (IBAction)onZipDone:(UITextField *)sender;

@end

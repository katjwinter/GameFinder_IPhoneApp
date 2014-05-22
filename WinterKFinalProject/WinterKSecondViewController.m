//
//  WinterKSecondViewController.m
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/25/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import "WinterKSecondViewController.h"

@interface WinterKSecondViewController ()

@end

@implementation WinterKSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"19-gear"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _dataModel = [WinterKSharedDataModel sharedData];
    _zipField.text = _dataModel.manualZip;
    [_zipSlider setOn:_dataModel.bManual];
    [_gamestopSlider setOn:_dataModel.bGameStop];
    [_bestbuySlider setOn:_dataModel.bBestBuy];
    if (!_zipSlider.isOn) {
        _zipLabel.enabled = NO;
        _zipLabel.alpha = 0.5;
        _zipField.enabled = NO;
        _zipField.alpha = 0.5;
    }
    else {
        _zipLabel.enabled = YES;
        _zipLabel.alpha = 1.0;
        _zipField.enabled = YES;
        _zipField.alpha = 1.0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// If return during editing of title, save the title and resign the field as first responder
- (IBAction)onZipDone:(UITextField *)sender {
    if (_zipField.text.length != 5) {
        // error
    }
    [sender resignFirstResponder];
}

// If white space is clicked while editing the title, save the title and end editing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_zipField.text.length != 5) {
        // error
    }
    [self.view endEditing:YES];
}

- (IBAction)manualZipChanged:(UISwitch *)sender {
    if (!sender.isOn) {
        _zipLabel.enabled = NO;
        _zipLabel.alpha = 0.5;
        _zipField.enabled = NO;
        _zipField.alpha = 0.5;
    }
    else {
        _zipLabel.enabled = YES;
        _zipLabel.alpha = 1.0;
        _zipField.enabled = YES;
        _zipField.alpha = 1.0;
    }
}

- (IBAction)onApply:(UIButton *)sender {
    if (_zipSlider.isOn) {
        // Check that we have a valid zip code
        // and if so, then do below (but if not, flash alert and do not apply)
        _dataModel.bManual = YES;
        _dataModel.manualZip = _zipField.text;
        // and open the first page
    }
    else {
        _dataModel.bManual = NO;
    }
    
    _dataModel.bGameStop = _gamestopSlider.isOn;
    _dataModel.bBestBuy = _bestbuySlider.isOn;
}

@end

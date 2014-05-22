//
//  WinterKFirstViewController.m
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/25/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import "WinterKFirstViewController.h"
#import "WinterKSharedDataModel.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface WinterKFirstViewController ()

@end

@implementation WinterKFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Search", @"Search");
        self.tabBarItem.image = [UIImage imageNamed:@"116-controller"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImageView *dropdownIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown.png"]];
    [_systemField setRightView:dropdownIcon];
    [_systemField setRightViewMode:UITextFieldViewModeAlways];
    
    _titleArray = [[NSMutableArray alloc] init];
    _systemArray = [[NSMutableArray alloc] init];
    [_systemArray addObject:@"XBox 360"];
    [_systemArray addObject:@"Sony PS3"];
    [_systemArray addObject:@"Sony Vita"];
    [_systemArray addObject:@"Nintendo DS"];
    [_systemArray addObject:@"Nintendo 3DS"];
    
    _gameSystem = [_systemArray objectAtIndex:0];
    
    [_titleChoiceView setAlpha:0];
    _titleChoiceView.hidden = YES;
    
    _titleChoicePicker.delegate = self;
    _titleChoicePicker.dataSource = self;
    _titleChoicePicker.showsSelectionIndicator = YES;
    
    _dataModel = [WinterKSharedDataModel sharedData];
    
    _zipCode = nil;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.distanceFilter = 3000.0f; // distance in meters
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Location Unavailable" message:@"Enable Location Services in your phone settings, or set a manual zip code in Game Finder's settings (gear icon below)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_dataModel.bManual) {
        _zipCode = _dataModel.manualZip;
    }
    else if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            _locationManager.distanceFilter = 3000.0f; // distance in meters
        }
        
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Location Unavailable" message:@"Enable Location Services in your phone settings, or set a manual zip code in Game Finder's settings (gear icon below)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTitleFieldTouch:(UITextField *)sender {
    if (_gameTitle == nil) {
        _titleField.text = @"";
    }
    // Create an erase button (and toolbar) as accessory view for clearing out the title field
    UIToolbar *titleToolBar = [[UIToolbar alloc] init];
    titleToolBar.barStyle = UIBarStyleBlack;
    titleToolBar.translucent = YES;
    titleToolBar.tintColor = nil;
    [titleToolBar sizeToFit];
    UIBarButtonItem *eraseButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(onTitleClear:)];
    [titleToolBar setItems:[NSArray arrayWithObjects:eraseButton, nil]];
    _titleField.inputAccessoryView = titleToolBar;
}

- (void)onTitleClear:(UIBarButtonItem *)sender {
    _gameTitle = nil;
    _titleField.text = @"";
}

// If return during editing of title, save the title and resign the field as first responder
- (IBAction)onTitleDone:(UITextField *)sender {
    if (_titleField.text.length == 0) {
        _gameTitle = nil;
    }
    else {
        _gameTitle = _titleField.text;
    }
    [sender resignFirstResponder];
}

// If white space is clicked while editing the title, save the title and end editing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_titleField.text.length == 0) {
        _gameTitle = nil;
    }
    else {
        _gameTitle = _titleField.text;
    }
    [self.view endEditing:YES];
}

- (IBAction)onSearch:(UIButton *)sender {
    _gameSystem = _systemField.text;
    if (_gameTitle == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Input" message:@"Game title must be filled in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"Search for: %@ on %@", _gameTitle, _gameSystem);
        [self initiateSearch];
    }
}

- (void)adjustAlphas:(float)alphaAmount {
    [_titleField setAlpha:alphaAmount];
    [_systemField setAlpha:alphaAmount];
    [_appLabel setAlpha:alphaAmount];
    [_titleLabel setAlpha:alphaAmount];
    [_systemLabel setAlpha:alphaAmount];
    [_searchButton setAlpha:alphaAmount];
}

- (void)initiateSearch {
    // Display the progress indicator
    [self adjustAlphas:0.2f];
    [_searchIndicator startAnimating];
    [_searchIndicatorText setAlpha:1.0f];
    
    // Encode query parameters
    _encodedGameTitle = [_gameTitle stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    _gameSystem = [_gameSystem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    // Send initial GET request to check for titles matching the given _gameTitle keywords
    NSString *url = [NSString stringWithFormat:@"http://localgamefinder.appspot.com/check?keywords=%@&system=%@", _encodedGameTitle, _gameSystem];
    NSLog(@"url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] init];
    (void)[conn initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Request is complete so parse the response
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Check if we need to ask the user to narow down the choices
    SMXMLDocument *document = [SMXMLDocument documentWithData:_responseData error:nil];
    SMXMLElement *rootElem = document.root;
    if ([rootElem.name isEqualToString:@"games"]) {
        // This a games response. See how many games we have.
        if ([rootElem.children count] > 1) {
            // We have more than 1 game, so we need to get the user to narrow them down
            [self showTitleOptions:rootElem];
        }
        else if ([rootElem.children count] == 1){
            // Only one game is a match, so we should verify with the user that this is the game they wanted
            NSString *result = @"";
            for (SMXMLElement *game in rootElem.children) {
                result = game.value;
            }
            NSString *msg = [NSString stringWithFormat:@"Is this the title you are looking for?\n%@", result];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title Found" message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Start Over", nil];
            [alert show];
        }
        else { // We did not get any titles in our results
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Sorry, we did not find the title you specified" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([rootElem.name isEqualToString:@"locations"]) {
        
        if ([rootElem.children count] < 1) {
            _dataModel.locationRoot = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Sorry, no stores near your location carry the title you specified" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            _dataModel.locationRoot = rootElem;
            [self.tabBarController setSelectedIndex:2];
        }
    }
    else {
        // Failure
        NSLog(@"FAILURE");
    }
    // Remove the progress indicator
    [self adjustAlphas:1.0f];
    [_searchIndicator stopAnimating];
    [_searchIndicatorText setAlpha:0.0f];
}

- (void)showTitleOptions:(SMXMLElement *)rootElem {
    [_titleArray removeAllObjects];
    
    for (SMXMLElement *game in rootElem.children) {
        [_titleArray addObject: [NSString stringWithFormat:@"%@", game.value]];
    }
    
    [_titleChoicePicker reloadAllComponents];
    
    [_titleChoiceView setAlpha:1];
    _titleChoiceView.hidden = NO;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Multiple Hits" message:@"Multiple titles match the one you entered. Select the specific title you want." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel Search", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonOption = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonOption isEqualToString:@"Cancel Search"]) {
        [_titleChoiceView setAlpha:0];
        _titleChoiceView.hidden = YES;
    }
    else if ([buttonOption isEqualToString:@"Yes"]) {
        [self locateGame];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Request failed
    NSLog(@"%@", error);
    // Remove the progress indicator
    [self adjustAlphas:1.0f];
    [_searchIndicator stopAnimating];
    [_searchIndicatorText setAlpha:0.0f];
}

- (IBAction)onSystemSelect:(UITextField *)sender {
    // Create the game system picker
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView sizeToFit];
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [pickerView setTag:0]; // for distinguishing from the title picker
    // Associate picker with the system selection text field
    _systemField.inputView = pickerView;
    
    // Create the done button toolbar
    UIToolbar *doneToolbar = [[UIToolbar alloc] init];
    doneToolbar.barStyle = UIBarStyleBlack;
    doneToolbar.translucent = YES;
    doneToolbar.tintColor = nil; // ?
    [doneToolbar sizeToFit];
    // Create the done button and associate it with an action
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onSystemPickerDone:)];
    // Add the done button to the toolbar
    [doneToolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    // Associate with the system selection text field as an accessory view
    _systemField.inputAccessoryView = doneToolbar;
    
}

-(void)onSystemPickerDone:(UIBarButtonItem *)sender {
    [_systemField resignFirstResponder];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag == 0) {
        _systemField.text = [_systemArray objectAtIndex:row];
    }
    else if (pickerView.tag == 1) {
        _gameTitle = [_titleArray objectAtIndex:row];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        return [_systemArray count];
    }
    else if (pickerView.tag == 1) {
        return [_titleArray count];
    }
    else {
        return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        return [_systemArray objectAtIndex:row];
    }
    else if (pickerView.tag == 1) {
        return [_titleArray objectAtIndex:row];
    }
    else {
        return 0;
    }
}


- (IBAction)onTitleChoiceCancel:(UIBarButtonItem *)sender {
    [_titleChoiceView setAlpha:0];
    _titleChoiceView.hidden = YES;
}

- (IBAction)onTitleChoiceDone:(UIBarButtonItem *)sender {
    [_titleChoiceView setAlpha:0];
    _titleChoiceView.hidden = YES;
    
    [self locateGame];
}

- (void)locateGame {
    if (_zipCode == nil) {
        // We haven't received a location yet. Alert the user and see if they want to try waiting a few more seconds,
        // or if they would prefer to just enter the zipcode manually
    }
    else {
        // Send request to find the game at stores in the user's vicinity
        // Display the progress indicator
        [self adjustAlphas:0.2f];
        [_searchIndicator startAnimating];
        [_searchIndicatorText setAlpha:1.0f];
        
        // Encode query parameters
        _gameTitle = [_gameTitle lowercaseString];
        _gameSystem = [_gameSystem lowercaseString];
        _encodedGameTitle = [_gameTitle stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        _gameSystem = [_gameSystem stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        // Send initial GET request to check for titles matching the given _gameTitle keywords
        NSString *url = [NSString stringWithFormat:@"http://localgamefinder.appspot.com/locate?title=%@&system=%@&zip=%@", _encodedGameTitle, _gameSystem, _zipCode];
        NSLog(@"url: %@", url);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *conn = [[NSURLConnection alloc] init];
        (void)[conn initWithRequest:request delegate:self];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 30.0) {
        // We have a recent location update, so turn off location service to preserve battery
        [_locationManager stopUpdatingLocation];
        
        // Ensure location data is available to the map view
        _dataModel.userLocation = location;
        
        // Translate location into a zip code
        CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
        if (reverseGeocoder) {
            [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark* placemark = [placemarks objectAtIndex:0];
                if (placemark) {
                    //Using blocks, get zip code
                    _zipCode = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
                    NSLog(@"ZIPCODE == %@", _zipCode);
                }
            }];
        }else{
            // IOS version too old. Alert user to input zipcode manually.
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Location Error" message:@"We are unable to extract zip code information from your location due to your IOS version. You can resolve this problem by upgrading to a new version of IOS. In the meantime, please enter your zipcode manually in Game Finder's settings (gear icon below)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

@end

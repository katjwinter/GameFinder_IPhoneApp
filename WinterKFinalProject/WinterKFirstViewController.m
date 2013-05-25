//
//  WinterKFirstViewController.m
//  WinterKFinalProject
//
//  Created by Kat Winter on 5/25/13.
//  Copyright (c) 2013 Kat Winter. All rights reserved.
//

#import "WinterKFirstViewController.h"

@interface WinterKFirstViewController ()

@end

@implementation WinterKFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

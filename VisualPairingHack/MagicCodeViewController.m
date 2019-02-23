//
//  MagicCodeViewController.m
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

#import "MagicCodeViewController.h"

#import "VisualPairing.h"

@interface MagicCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *codeContainer;
@property (nonatomic, strong) VPPresenterView *codeView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation MagicCodeViewController

- (instancetype)init
{
    self = [super init];

    self.title = @"Generate";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Generate" image:[UIImage imageNamed:@"generate"] tag:0];

    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _configureAsPresenter];
}

- (void)_configureAsPresenter
{
    CGFloat codeSize = 300;

    self.codeContainer = [UIView new];

    self.codeContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeContainer.clipsToBounds = YES;

    self.codeContainer.backgroundColor = [UIColor whiteColor];
    self.codeContainer.layer.cornerRadius = codeSize/2;
    self.codeContainer.layer.borderColor = [UIColor colorWithRed:0.00 green:0.49 blue:1.00 alpha:1.00].CGColor;
    self.codeContainer.layer.borderWidth = 1;

    [self.view addSubview:self.codeContainer];

    [self.codeContainer.widthAnchor constraintEqualToConstant:codeSize].active = YES;
    [self.codeContainer.heightAnchor constraintEqualToConstant:codeSize].active = YES;
    [self.codeContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.codeContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    [self _installParticles];

    self.codeView = [[NSClassFromString(@"VPPresenterView") alloc] initWithFrame:CGRectZero];
    self.codeView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.codeContainer addSubview:self.codeView];

    [self.codeView.widthAnchor constraintEqualToAnchor:self.codeContainer.widthAnchor].active = YES;
    [self.codeView.heightAnchor constraintEqualToAnchor:self.codeContainer.heightAnchor].active = YES;
    [self.codeView.centerXAnchor constraintEqualToAnchor:self.codeContainer.centerXAnchor].active = YES;
    [self.codeView.centerYAnchor constraintEqualToAnchor:self.codeContainer.centerYAnchor].active = YES;

    [self.codeView setVerificationCode:@"Hello, world"];

    [self _installCodeField];
}

- (void)_installParticles
{
    NSData *assetData = [[NSDataAsset alloc] initWithName:@"particles"].data;
    if (!assetData) return;

    NSDictionary *caar = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    CALayer *rootLayer = caar[@"rootLayer"];
    if (!rootLayer) return;

    [self.codeContainer.layer addSublayer:rootLayer];
}

- (void)_installCodeField
{
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.text = @"Hello, world";
    self.textField.placeholder = @"Enter code to transmit";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;

    self.textField.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.textField];

    [self.textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16].active = YES;
    [self.textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16].active = YES;
    [self.textField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16].active = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.codeView start];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.codeView stop];

    self.codeView.verificationCode = textField.text;

    [self.codeView start];

    [self.textField resignFirstResponder];

    return YES;
}

@end

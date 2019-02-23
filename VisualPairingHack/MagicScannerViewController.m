//
//  MagicScannerViewController.m
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

#import "MagicScannerViewController.h"

#import "VisualPairing.h"

@interface MagicScannerViewController ()

@property (nonatomic, strong) VPScannerViewController *scannerController;
@property (nonatomic, strong) UINotificationFeedbackGenerator *feedback;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation MagicScannerViewController

- (instancetype)init
{
    self = [super init];

    self.title = @"Scan";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Scan" image:[UIImage imageNamed:@"scan"] tag:1];

    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _configureAsScanner];
}

- (void)_configureAsScanner
{
    self.feedback = [UINotificationFeedbackGenerator new];

    self.scannerController = [NSClassFromString(@"VPScannerViewController") instantiateViewController];
    self.scannerController.titleMessage = @"Hold the device that's generating the code up to the camera.";
    self.scannerController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.scannerController.view];
    
    [self.scannerController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scannerController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.scannerController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.scannerController.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    __weak typeof(self) weakSelf = self;
    self.scannerController.scannedCodeHandler = ^(NSString *code) {
        NSLog(@"SCANNED: %@", code);

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf _didScanCode:code];
        });
    };

    [self addChildViewController:self.scannerController];
    [self.scannerController didMoveToParentViewController:self];

    [self _installResultLabel];
}

- (void)_installResultLabel
{
    self.resultLabel = [UILabel new];
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.resultLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.resultLabel.textColor = [UIColor blackColor];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultLabel];
    self.resultLabel.text = @"Waiting for scan...";

    [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16].active = YES;
    [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16].active = YES;
    [self.resultLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16].active = YES;
}

- (void)_didScanCode:(NSString *)code
{
    if ([code isEqualToString:self.resultLabel.text]) return;

    [self.feedback notificationOccurred:UINotificationFeedbackTypeSuccess];
    self.resultLabel.text = code;
}

@end

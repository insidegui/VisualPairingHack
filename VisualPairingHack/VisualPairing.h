//
//  VisualPairing.h
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@interface VPScannerViewController : UIViewController

+ (instancetype)instantiateViewController;

@property(copy, nonatomic) NSString *titleMessage;
@property(copy, nonatomic) void(^scannedCodeHandler)(NSString *);

@end

@interface VPPresenterView: UIView

- (void)start;
- (void)stop;

@property (nonatomic, copy) NSString *verificationCode;

@end

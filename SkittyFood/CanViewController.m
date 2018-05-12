//
//  CanViewController.m
//  SkittyFood
//
//  Created by Daniel A. Weiner on 5/12/18.
//  Copyright © 2018 Daniel Weiner. All rights reserved.
//

#import "CanViewController.h"

@interface CanViewController ()

@property NSArray *quarterViews;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;

- (IBAction)tappedFirstQuarter:(id)sender;
- (IBAction)tappedThirdQuarter:(id)sender;
- (IBAction)tappedFourthQuater:(id)sender;
- (IBAction)tappedSecondQuarter:(id)sender;

@end

@implementation CanViewController {
    NSInteger _amountOfFood;
    NSUserDefaults *defaults;
}

- (void)viewDidLoad	 {
    [super viewDidLoad];
    
    self.canFoodColor = UIColor.lightGrayColor;
    
    self.quarterViews = @[
        self.firstView,
        self.secondView,
        self.thirdView,
        self.fourthView
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.layer.cornerRadius = CGRectGetWidth(self.view.frame) / 2;
    self.view.layer.borderWidth = 6;
    self.view.layer.borderColor = UIColor.blackColor.CGColor;
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)setAmountOfFood:(NSInteger)amountOfFood {
    NSAssert(amountOfFood >= 1 || amountOfFood <= 4, @"amountOfFood must be between 1 and 4 inclusive");
    _amountOfFood = amountOfFood;
    [self.delegate canViewController:self didSetFood:amountOfFood];
    NSInteger hideBeforeIndex = 4 - amountOfFood;
    [self.quarterViews enumerateObjectsUsingBlock:^(UIView* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < hideBeforeIndex) {
            obj.backgroundColor = UIColor.clearColor;
        } else {
            obj.backgroundColor = self.canFoodColor;
        }
    }];
}

- (NSInteger)amountOfFood {
    return _amountOfFood;
}

- (IBAction)tappedFirstQuarter:(id)sender {
    self.amountOfFood = 4;
}

- (IBAction)tappedSecondQuarter:(id)sender {
    self.amountOfFood = 3;
}

- (IBAction)tappedThirdQuarter:(id)sender {
    self.amountOfFood = 2;
}

- (IBAction)tappedFourthQuater:(id)sender {
    self.amountOfFood = 1;
}
@end

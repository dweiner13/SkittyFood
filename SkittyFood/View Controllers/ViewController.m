//
//  ViewController.m
//  SkittyFood
//
//  Created by Daniel A. Weiner on 5/12/18.
//  Copyright © 2018 Daniel Weiner. All rights reserved.
//

#import "ViewController.h"
#import "CanViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property NSInteger amountOfFoodAtStart;
@property (readonly) NSInteger eodFoodAmount;
@property (weak, nonatomic) IBOutlet UIView *interactiveCanViewContainerView;
@property (readonly) bool needsNewCan;
@property (weak, nonatomic) IBOutlet UIView *infoCanViewContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (readonly) NSString* infoLabelText;
@end

NSString *kAmountOfFoodAtStartKey = @"amountOfFoodAtStartKey";
NSString *kLastUpdatedKey = @"dateFoodAtStartLastUpdated";

@implementation ViewController {
    NSInteger _amountOfFoodAtStart;
    NSDate *lastUpdated;
    NSUserDefaults *defaults;
    NSInteger amountOfFoodHeEatsPerDay;
    
    CanViewController *interactiveCanViewController;
    CanViewController *infoCanViewController;
    
    NSDateFormatter *lastUpdatedFormatter;
    
    UISelectionFeedbackGenerator *feedbackGenerator;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    amountOfFoodHeEatsPerDay = 3;
    
    infoCanViewController = self.childViewControllers.lastObject;
    infoCanViewController.shouldBeEditable = NO;
    interactiveCanViewController = self.childViewControllers.firstObject;
    interactiveCanViewController.delegate = self;
    interactiveCanViewController.canFoodColor = [UIColor colorWithRed:0 green:0.589 blue:1 alpha:1];
    
    feedbackGenerator = [UISelectionFeedbackGenerator new];
    
    lastUpdatedFormatter = [NSDateFormatter new];
    lastUpdatedFormatter.doesRelativeDateFormatting = YES;
    lastUpdatedFormatter.dateStyle = NSDateFormatterShortStyle;
    lastUpdatedFormatter.timeStyle = NSDateFormatterShortStyle;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger saved = [defaults integerForKey:kAmountOfFoodAtStartKey];
    NSDate *savedLastUpdated = (NSDate *)[defaults objectForKey:kLastUpdatedKey];
    [self updateLastUpdatedLabelWithDate:savedLastUpdated];
    if (savedLastUpdated) {
        lastUpdated = savedLastUpdated;
    }
    if (saved == 0) {
        saved = 4;
    }
    interactiveCanViewController.amountOfFood = saved;
}

- (void)updateLastUpdatedLabelWithDate:(NSDate *)date {
    NSString *formatted = [lastUpdatedFormatter stringFromDate:date];
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Last updated %@", formatted];
}

- (void)setAmountOfFoodAtStart:(NSInteger)amountOfFoodAtStart {
    [feedbackGenerator selectionChanged];
    NSDate *now = [NSDate new];
    lastUpdated = now;
    [self updateLastUpdatedLabelWithDate:now];
    
    [defaults setObject:now forKey:kLastUpdatedKey];
    [defaults setInteger:amountOfFoodAtStart forKey:kLastUpdatedKey];
    [defaults synchronize];
    
    self.infoLabel.text = self.infoLabelText;
    infoCanViewController.amountOfFood = self.eodFoodAmount;

    [self popView:self.interactiveCanViewContainerView];
}

- (NSInteger)amountOfFoodAtStart {
    NSInteger saved = [defaults integerForKey:kLastUpdatedKey];
    if (saved == 0) {
        saved = 4;
    }
    return saved;
}

- (bool)needsNewCan {
    return self.amountOfFoodAtStart < amountOfFoodHeEatsPerDay;
}


- (NSInteger)eodFoodAmount {
    NSInteger result = self.amountOfFoodAtStart - amountOfFoodHeEatsPerDay;
    if (self.needsNewCan) {
        result = 4 + result;
    }
    return result;
}

- (void)popView:(UIView *)view {
    [UIView animateWithDuration:0.05
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                                    [view setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
                                }
                     completion:^(BOOL finished) {
                                    [UIView animateWithDuration:0.05 animations:^{
                                        [view setTransform:CGAffineTransformIdentity];
                                    }];
                                }
     ];
}

- (NSString *)infoLabelText {
    bool needNewCan = self.needsNewCan;
    NSString* result = @"";
    if (needNewCan) {
        result = [result stringByAppendingString:@"You will need to open a new can. "];
    }
    result = [result stringByAppendingString:@"At the end of the day, you should have a can that looks like:"];
    return result;
}

- (void)canViewController:(CanViewController *)canViewController didSetFood:(NSInteger)food {
    NSLog(@"Main view controller set food: %li", food);
    self.amountOfFoodAtStart = food;
}

@end

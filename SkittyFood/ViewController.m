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
@property (readonly) bool needsNewCan;
@property (readonly) NSString* infoLabelText;
@end

@implementation ViewController {
    NSInteger _amountOfFoodAtStart;
    NSUserDefaults *defaults;
    NSString *amountOfFoodAtStartKey;
    NSInteger amountOfFoodHeEatsPerDay;
    
    CanViewController *interactiveCanView;
    CanViewController *infoCanView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    amountOfFoodAtStartKey = @"amountOfFoodAtStartKey";
    amountOfFoodHeEatsPerDay = 3;
    
    infoCanView = self.childViewControllers.lastObject;
    interactiveCanView = self.childViewControllers.firstObject;
    interactiveCanView.delegate = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger saved = [defaults integerForKey:amountOfFoodAtStartKey];
    if (saved == 0) {
        saved = 4;
    }
    NSLog(@"%li", (long)saved);
    interactiveCanView.amountOfFood = saved;
}

- (void)setAmountOfFoodAtStart:(NSInteger)amountOfFoodAtStart {
    NSLog(@"%li", amountOfFoodAtStart);
    [defaults setInteger:amountOfFoodAtStart forKey:amountOfFoodAtStartKey];
    [defaults synchronize];
    self.infoLabel.text = self.infoLabelText;
    infoCanView.amountOfFood = self.eodFoodAmount;
}

- (NSInteger)amountOfFoodAtStart {
    NSInteger saved = [defaults integerForKey:amountOfFoodAtStartKey];
    if (saved == 0) {
        saved = 4;
    }
    return saved;
}

- (bool)needsNewCan {
    NSLog(@"foo");
    return self.amountOfFoodAtStart < amountOfFoodHeEatsPerDay;
}


- (NSInteger)eodFoodAmount {
    NSLog(@"bar");
    NSInteger result = self.amountOfFoodAtStart - amountOfFoodHeEatsPerDay;
    if (self.needsNewCan) {
        result = 4 + result;
    }
    return result;
}

- (NSString *)infoLabelText {
    NSLog(@"foobar");
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

//
//  CanViewController.h
//  SkittyFood
//
//  Created by Daniel A. Weiner on 5/12/18.
//  Copyright © 2018 Daniel Weiner. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CanViewController;

@protocol CanViewControllerDelegate <NSObject>
- (void) canViewController:(CanViewController *)canViewController didSetFood: (NSInteger) food;
@end

@interface CanViewController : UIViewController
@property (nonatomic, weak) id <CanViewControllerDelegate> delegate;
@property NSInteger amountOfFood;
@property UIColor *canFoodColor;
@end

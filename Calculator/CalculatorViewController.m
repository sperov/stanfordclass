//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDotAlready;
@property (nonatomic, strong) CalculatorBrain* brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDotAlready = _userHasEnteredDotAlready;
@synthesize brain = _brain;

- (CalculatorBrain*) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init]; 
    return _brain;
}

- (IBAction)digitPress:(UIButton *)sender 
{
    NSString* digit = sender.currentTitle;
    
    if([digit isEqualToString:@"."]) {
        if (self.userHasEnteredDotAlready == YES) return;
        else self.userHasEnteredDotAlready = YES;
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) 
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit; 
        self.userIsInTheMiddleOfEnteringANumber = YES; 
    }

 }
- (IBAction) enterPressed  
{

    if ([self.display.text hasPrefix:@"."]) {
        [self.brain pushOperand:[[@"0" stringByAppendingString:self.display.text] doubleValue]];
    } else {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDotAlready = NO;

}
- (IBAction) operationPressed :(UIButton *) sender{

    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

@end

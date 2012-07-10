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
@property (weak, nonatomic) IBOutlet UILabel *displayInput;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDotAlready = _userHasEnteredDotAlready;
@synthesize brain = _brain;
@synthesize displayInput = _displayInput;

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
    // populate the Label with the digit pressed 
    
    self.displayInput.text = [NSString stringWithFormat:@"%@ %@", self.displayInput.text, self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDotAlready = NO;

}
- (IBAction) operationPressed :(UIButton *) sender{

    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    self.displayInput.text = [NSString stringWithFormat:@"%@ %@",self.displayInput.text, sender.currentTitle];
    self.display.text = resultString;
}
- (IBAction)clearSequence:(UIButton *)sender {
    self.displayInput.text = nil;
}
- (IBAction)clearAll:(UIButton*)sender {

    [self.brain clearAll]; // clear the array
    self.displayInput.text = @""; // clear the displays
    self.display.text = @""; // clear the displays
    // clear state variables
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDotAlready = NO;
}

@end

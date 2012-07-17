//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sergey Perov on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()

// properties
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDotAlready;
@property (nonatomic, strong) CalculatorBrain* brain;
@property (strong, nonatomic) NSDictionary *testVariableValues;

// private outlets 
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *displayInput;
@property (weak, nonatomic) IBOutlet UILabel *varOutlet;

// all the private methods
- (void) updateVarOutlet;
- (void) updateDisplay;

@end

@implementation CalculatorViewController


@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDotAlready = _userHasEnteredDotAlready;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

@synthesize display = _display;
@synthesize displayInput = _displayInput;
@synthesize varOutlet = _varOutlet;

- (CalculatorBrain*) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init]; 
    return _brain;
}

- ( NSDictionary*) testVariableValues {
    if (_testVariableValues == nil) {
        _testVariableValues = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"x", @"2", @"y", @"3", @"foo", nil];
    }
    return _testVariableValues;
}

- (void) setTestVariableValues:(NSDictionary *)testVariableValues {
    _testVariableValues = [[NSDictionary alloc] initWithDictionary:testVariableValues];
}

// UI updaters
- (void) updateVarOutlet {
    NSSet* variableNames = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSString* currentValue;
    NSString* outputString = @"";
    for (NSString* currentObject in variableNames) {
        currentValue = [self.testVariableValues objectForKey:currentObject];
        if (currentValue) {
            outputString = [NSString stringWithFormat:@"%@ %@ = %@", outputString, currentObject, currentValue];
        } else {
            outputString = [NSString stringWithFormat:@"%@ %@ = 0", outputString, currentObject];
        }
    }
    self.varOutlet.text = outputString;
}

- (void) updateDisplay {
    // double result = [CalculatorBrain runProgram:self.brain.program usingVariableValue:self.testVariableValues];
    // self.display.text = [NSString stringWithFormat:@"%g", result]; 
    self.display.text = [CalculatorBrain getLastDisplayValue:self.brain.program usingVariableValue:self.testVariableValues];
    self.displayInput.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
}

// Actions

- (IBAction)undoPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {

        NSString* currentDisplayValue = [self.display.text substringToIndex:([self.display.text length] - 1)];
        if ([currentDisplayValue isEqualToString:@""]) {

            NSString* previousCalculatedValue = [CalculatorBrain getLastDisplayValue:self.brain.program usingVariableValue:self.testVariableValues];
            self.display.text = previousCalculatedValue; 
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            self.display.text = currentDisplayValue;
        }
    }
}

- (IBAction)testPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Test 1"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"x", @"-1000", @"y", @"", @"foo", nil];
    }
    
    if ([sender.currentTitle isEqualToString:@"Test 2"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"x", @"200", @"y", @"300", @"foo", nil];
    }
    
    if ([sender.currentTitle isEqualToString:@"Test 3"]){
        //self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@"300", @"x", @"400", @"y", @"500", @"foo", nil];
        self.testVariableValues = nil;
    }
    [self updateVarOutlet];
    [self updateDisplay];
}

- (IBAction)digitPress:(UIButton *)sender 
{
    NSString* digit = sender.currentTitle;
    
    if([digit isEqualToString:@"."]) {
        if (self.userHasEnteredDotAlready == YES) return;
        else self.userHasEnteredDotAlready = YES;
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) 
    {           self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit; 
        self.userIsInTheMiddleOfEnteringANumber = YES; 
    }

 }

- (IBAction)variablePress:(UIButton *)sender {
    NSString* variable = sender.currentTitle;
    self.display.text = variable;
    [self.brain pushOperand:variable];
    self.displayInput.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    // variables used in the program
    [self updateVarOutlet];
}


- (IBAction) enterPressed  
{
    // convert to NSNumber right here before pushing
    if ([self.display.text hasPrefix:@"."]) {
        NSString* stringWithLeadingZero = [@"0" stringByAppendingString:self.display.text];
       [self.brain pushOperand:[NSNumber numberWithDouble:[stringWithLeadingZero doubleValue]]];
    } else {
        [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
    }
    // populate the Label with the digit pressed 
    
    //self.displayInput.text = [NSString stringWithFormat:@"%@ %@", self.displayInput.text, self.display.text];
    self.displayInput.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDotAlready = NO;

}
- (IBAction) operationPressed :(UIButton *) sender{

    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle usingVariableValue:self.testVariableValues];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    //self.displayInput.text = [NSString stringWithFormat:@"%@ %@",self.displayInput.text, sender.currentTitle];
    self.displayInput.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.display.text = resultString;
}

- (IBAction)clearAll:(UIButton*)sender {

    [self.brain clearAll]; // clear the array
    self.displayInput.text = @""; // clear the displays
    self.display.text = @"0"; // clear the displays
    // clear state variables
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDotAlready = NO;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Graph"]) {
        NSMutableArray* runProgramResults = [[NSMutableArray alloc] initWithCapacity:1]; // try it with 1 point only first
        [runProgramResults addObject:[NSNumber numberWithDouble:[CalculatorBrain runProgram:self.brain.program usingVariableValue:self.testVariableValues]]]; 
        [segue.destinationViewController setProgram:self.brain.program];
    }
}
@end

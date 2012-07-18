//
//  GraphViewController.m
//  Calculator
//
//  Created by Sergey Perov on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView* graphView; 
@property (nonatomic, weak) IBOutlet UILabel *graphDescription;
@property (nonatomic, strong) UIBarButtonItem* splitViewBarButtonItem;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;
@synthesize graphDescription = _graphDescription;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;


- (void) awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void) setProgram:(NSArray *)program {
    if(_program != program) {
        _program = program;
    }
    [self.graphView setNeedsDisplay];
}

- (void) setGraphView:(GraphView*) graphView {
    _graphView = graphView;
    // add gesture recognisers here
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
     [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGestureRecognizer];
    self.graphView.dataSource = self;
    self.graphDescription.text = [CalculatorBrain descriptionOfProgram:self.program]; // is this legit to be calling model class method from another controller
}


- (CGFloat) getProgramValue:(CGFloat) xValue {
    
    NSDictionary* xVariableValue = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", xValue], @"x",nil];
    return [CalculatorBrain runProgram:self.program usingVariableValue:xVariableValue]; // need to add coordinates conversion
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem ) {
        NSMutableArray* toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems; 
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (BOOL) splitViewController:(UISplitViewController *) svc 
    shouldHideViewController:(UIViewController* )vc 
               inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) splitViewController:(UISplitViewController*) svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
  //  id calcViewController = [self.splitViewController.viewControllers objectAtIndex:0];
    barButtonItem.title = @"Calculator";
    self.splitViewBarButtonItem = barButtonItem;

}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    self.splitViewBarButtonItem = nil;

}

@end

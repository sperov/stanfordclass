
//
//  GraphView.h
//  Calculator
//
//  Created by Sergey Perov on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;
@protocol GraphViewDataSource
- (CGFloat) getProgramValue:(CGFloat) xValue; 
@end

@interface GraphView : UIView
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end

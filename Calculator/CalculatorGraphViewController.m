//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Carpenter, Donal [ICG-IT] on 2/12/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphViewController ()

@end

@implementation CalculatorGraphViewController

@synthesize program = _program;
@synthesize graphView = _graphView;


-(void) setGraphView:(CalculatorGraphView *)graphView{
    _graphView = graphView;
    
    // make sure we add a ref bak to ourself as the data source
    _graphView.dataSource = self;
}

- (double) yForX:(double)x{
    double result = 0;
    
    NSDictionary* variables = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x], @"x", nil];
    
    
    result = [CalculatorBrain runProgram: self.program
                     usingVariableValues: variables];
    
    return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

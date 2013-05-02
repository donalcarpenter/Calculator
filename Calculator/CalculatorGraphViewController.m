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
@synthesize toolbarButtons = _toolbarButtons;


-(void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(NSArray *) program{
    return _program;
}

-(BOOL) hasProgramBeenDefined{
    return _program != nil;
}

-(void) setProgram:(NSArray *)program{
    if(program == _program){
        return;
    }
    
    _program = nil;
    _program = program;
    [self.graphView setNeedsDisplay];
}


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
    
    self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// Called when a button should be added to a toolbar for a hidden view controller.
// Implementing this method allows the hidden view controller to be presented via a swipe gesture if 'presentsWithGesture' is 'YES' (the default).
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";

    NSMutableArray* existingButtons = [self.toolbarButtons.items mutableCopy];
    [existingButtons insertObject:barButtonItem atIndex:0];
    self.toolbarButtons.items = existingButtons;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray* existingButtons = [self.toolbarButtons.items mutableCopy];
    [existingButtons removeObject:barButtonItem];
    self.toolbarButtons.items = existingButtons;
}

// Returns YES if a view controller should be hidden by the split view controller in a given orientation.
// (This method is only called on the leftmost view controller and only discriminates portrait from landscape.)
- (BOOL)splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}


@end

//
//  ViewController.m
//  PAExtendedScrollView
//
//  Created by Philippe Auriach on 25/08/13.
//  Copyright (c) 2013 Philippe Auriach. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    scrollContent = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    scrollView = [[PAExtendedScrollView alloc]
                         initWithFrameAndPageSize:CGRectMake(0, 0, 320, 260)
                         pageSize:CGSizeMake(240, 245)];
    scrollView.delegate = self;
    [scrollView setBackgroundColor:[UIColor redColor]];
    [self.scrollViewContainer addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PAExtendedScrollViewDelegate
-(UIView *)viewForItemAtIndex:(PAExtendedScrollView *)scrollView index:(int)index{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];

    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 220, 220)];
    [bg setBackgroundColor:[UIColor grayColor]];
    [v addSubview:bg];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 20, 20)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[scrollContent objectAtIndex:index]];
    [v addSubview:lbl];
    
    return v;
}

-(int)numberOfItemForScrollView:(PAExtendedScrollView *)scrollView{
    return [scrollContent count];
}

-(void)scrollViewDidScroll:(PAExtendedScrollView *)sv{
    //scrollview scroll
}

-(void)scrollViewDidEndDecelerating:(PAExtendedScrollView *)sv{
    NSLog(@"Did stop scroll at view : %d", [sv currentPage]);
}

@end

//
//  ViewController.h
//  PAExtendedScrollView
//
//  Created by Philippe Auriach on 25/08/13.
//  Copyright (c) 2013 Philippe Auriach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAExtendedScrollView.h"

@interface ViewController : UIViewController<PAExtendedScrollViewDelegate>{
    NSArray *scrollContent;
    PAExtendedScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;

@end

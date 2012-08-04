//
//  MainWindow.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "MainWindow.h"
#import "Constants.h"

@implementation MainWindow

@synthesize engineView;

-(void)awakeFromNib
{    
    engineView = [[Engine2DView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_EDITOR, SCREEN_HEIGHT_EDITOR)];

    [self addSubview:engineView];
    [engineView release];
    
    NSLog(@"MainWindow initialized");
}


@end

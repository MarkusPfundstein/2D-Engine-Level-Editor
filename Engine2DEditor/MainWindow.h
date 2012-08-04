//
//  MainWindow.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "Engine2DView.h"

@interface MainWindow : NSView
{
    Engine2DView *engineView;

}

@property (nonatomic, retain) Engine2DView *engineView;

@end

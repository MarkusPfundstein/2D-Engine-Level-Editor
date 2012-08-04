//
//  Engine2DView.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "Communicator.h"

@interface Engine2DView : NSOpenGLView

-(void)handleScrolling: (int) direction WithSpeed: (int) scrollSpeed;

@end

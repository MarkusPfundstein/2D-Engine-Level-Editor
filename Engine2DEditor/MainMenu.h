//
//  MainMenu.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/18/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MainMenu : NSMenu

-(IBAction)openMap:(id)sender;
-(IBAction)newMap:(id)sender;
-(IBAction)saveMap:(id)sender;
-(IBAction)openScriptEditor:(id)sender;

@end

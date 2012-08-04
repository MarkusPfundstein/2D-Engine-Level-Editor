//
//  ToolWindow.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/22/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ToolWindow : NSView
{
    IBOutlet NSTextField *txtFldRows;
    IBOutlet NSTextField *txtFldCols;
    IBOutlet NSButton *btnShowLayer1;
    IBOutlet NSButton *btnShowLayer2;
    IBOutlet NSButton *btnShowLayer3;
    IBOutlet NSButton *btnEditWalkable;
    IBOutlet NSImageView *activeTile;
}

@property (nonatomic, retain) IBOutlet NSTextField *txtFldRows;
@property (nonatomic, retain) IBOutlet NSTextField *txtFldCols;
@property (nonatomic, retain) IBOutlet NSButton *btnShowLayer1;
@property (nonatomic, retain) IBOutlet NSButton *btnShowLayer2;
@property (nonatomic, retain) IBOutlet NSButton *btnShowLayer3;
@property (nonatomic, retain) IBOutlet NSButton *btnEditWalkable;
@property (nonatomic, retain) IBOutlet NSImageView *activeTile;

-(IBAction)changeSizeButtonPressed:(id)sender;
-(IBAction)readBtnShowLayer1:(id)sender;
-(IBAction)readBtnShowLayer2:(id)sender;
-(IBAction)readBtnShowLayer3:(id)sender;
-(IBAction)readBtnEditWalkable:(id)sender;

@end

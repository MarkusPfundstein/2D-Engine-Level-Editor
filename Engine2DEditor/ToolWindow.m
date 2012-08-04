//
//  ToolWindow.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/22/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "ToolWindow.h"
#import "Communicator.h"
#import "Helpers.h"

@implementation ToolWindow
@synthesize txtFldCols;
@synthesize txtFldRows;
@synthesize btnShowLayer1;
@synthesize btnShowLayer2;
@synthesize btnShowLayer3;
@synthesize btnEditWalkable;
@synthesize activeTile;

- (void) awakeFromNib
{
    NSLog(@"ToolWindow initialized");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MSG_updateWalkableBtn) name:@"updateWalkableButton" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MSG_updateActiveTile) name:@"updateActiveTileImage" object:nil];
    
    [btnEditWalkable setState:NSOffState];
}

-(void) MSG_updateActiveTile
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if (com.activeTileImage!=nil)
        [activeTile setImage:com.activeTileImage];
    else
        [activeTile setImage:nil];
}

-(void) MSG_updateWalkableBtn
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if (com.isInWalkableMode)
    {
        [com setIsInWalkableMode:NO];
        [btnEditWalkable setState:NSOffState];
    }
    else
    {
        [com setIsInWalkableMode:YES];
        [btnEditWalkable setState:NSOnState];
    }
}

-(IBAction)changeSizeButtonPressed:(id)sender
{
    if (alertBoxYesNo(@"Do you really want to resize the map? (If you make it smaller, tiles outside the new size are lost)"))
    {
        Communicator *com = [Communicator sharedCommunicator];

        [com setNewRows:txtFldRows.intValue];
        [com setNewCols:txtFldCols.intValue];


        [[NSNotificationCenter defaultCenter] postNotificationName:@"resize_map" object:nil];
    }
}

-(IBAction)readBtnShowLayer1:(id)sender
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if ([btnShowLayer1 state]==NSOnState)
        [com setDrawLayer1:YES];
    else
        [com setDrawLayer1:NO];
}
-(IBAction)readBtnShowLayer2:(id)sender
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if ([btnShowLayer2 state]==NSOnState)
        [com setDrawLayer2:YES];
    else
        [com setDrawLayer2:NO];
}
-(IBAction)readBtnShowLayer3:(id)sender
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if ([btnShowLayer3 state]==NSOnState)
        [com setDrawLayer3:YES];
    else
        [com setDrawLayer3:NO];
}

-(IBAction)readBtnEditWalkable:(id)sender
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if ([btnEditWalkable state]==NSOnState)
        [com setIsInWalkableMode:YES];
    else 
        [com setIsInWalkableMode:NO];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleWalkable" object:nil];
}

-(void)dealloc
{
    [btnEditWalkable release];
    [btnShowLayer1 release];
    [btnShowLayer2 release];
    [btnShowLayer3 release];
    [txtFldCols release];
    [txtFldRows release];
    [activeTile release];
    [super dealloc];
}


@end

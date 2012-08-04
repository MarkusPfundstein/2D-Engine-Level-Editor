//
//  Engine2DView.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <OpenGL/gl.h>

#import "Engine2DView.h"
#import "Constants.h"
#import "Editor.h"


Editor *editor;

@implementation Engine2DView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        editor = new Editor();
    }
    
    return self;
}


-(void)drawRect:(NSRect)dirtyRect
{
    editor->initScene();

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSG_openMap) name:@"menu_load_new_map" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSG_startNew) name:@"menu_start_new_map" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSG_resizeMap) name:@"resize_map" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSG_saveMap) name:@"menu_save_map" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSG_toggleWalkable) name:@"toggleWalkable" object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    Communicator *com = [Communicator sharedCommunicator];
    [com setDrawLayer1:YES];
    [com setDrawLayer2:YES];
    [com setDrawLayer3:YES];
    [com setIsInWalkableMode:NO];
}

-(void)handleScrolling: (int) direction WithSpeed: (int) scrollSpeed;
{
    switch (direction)
    {          
        case UP:
            editor->scrollMap(UP, 64.0f);            
            break;
        case LEFT:
            editor->scrollMap(LEFT, 64.0f);
            break;
        case RIGHT:
            editor->scrollMap(RIGHT, 64.0f);
            break;
        case DOWN:
            editor->scrollMap(DOWN, 64.0f);
            break;
    }
}

-(void)mouseDown:(NSEvent *)theEvent
{


    Communicator *com = [Communicator sharedCommunicator];
    
    if (com.isInWalkableMode)
    {
        editor->changeTileWalkableAt([theEvent locationInWindow].x, [theEvent locationInWindow].y);
    }
    else if (com.changeTile) 
    {
        editor->changeTileAt([theEvent locationInWindow].x, [theEvent locationInWindow].y, com.tile_id, com.onLayer);
    }

}

-(void)mouseDragged:(NSEvent *)theEvent
{
    Communicator *com = [Communicator sharedCommunicator];
    
    
    if (com.changeTile) 
    {
        editor->changeTileAt([theEvent locationInWindow].x, [theEvent locationInWindow].y, com.tile_id, com.onLayer);
    }
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if (com.changeTile && com.onLayer !=0)
    {
        editor->changeTileAt([theEvent locationInWindow].x, [theEvent locationInWindow].y, NO_TILE_ID, com.onLayer);
    }
}

-(void)rightMouseDragged:(NSEvent *)theEvent
{

    editor->moveCameraWith(-[theEvent deltaX], [theEvent deltaY]);
    
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)update
{
    editor->updateScene();
}

-(void)clearMouseInputs
{
    Communicator *com = [Communicator sharedCommunicator];
    
    if (com.isInWalkableMode)
    {
        editor->setWalkable(0);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWalkableButton" object:nil];
    }
    if (com.changeTile)
    {
        [com setChangeTile:NO];
        [com setActiveTileImage:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateActiveTileImage" object:nil];   
    }
    

}

-(void)keyDown:(NSEvent *)theEvent
{
    Communicator *com = [Communicator sharedCommunicator];
    switch ([theEvent keyCode])
    {          
        case KEY_ESC:
            [self clearMouseInputs];
            break;
        case KEY_UP:
            [self handleScrolling:UP WithSpeed:64.0f];          
            break;
        case KEY_LEFT:
            [self handleScrolling:LEFT WithSpeed:64.0f]; 
            break;
        case KEY_RIGHT:
            [self handleScrolling:RIGHT WithSpeed:64.0f];
            break;
        case KEY_DOWN:
            [self handleScrolling:DOWN WithSpeed:64.0f];
            break;
        case KEY_W:
            editor->toggleWalkable();
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateWalkableButton" object:nil];
            break;
        case KEY_1:
            [com setOnLayer:1];
            NSLog(@"Layer: %d", com.onLayer);
            break;
        case KEY_2:
            [com setOnLayer:2];
            NSLog(@"Layer: %d", com.onLayer);
            break;
        case KEY_7:
            if (com.drawLayer1)
                [com setDrawLayer1:NO];
            else 
                [com setDrawLayer1:YES];
            break;
        case KEY_8:
            if (com.drawLayer2)
                [com setDrawLayer2:NO];
            else 
                [com setDrawLayer2:YES];
            break;
        case KEY_9:
            if (com.drawLayer3)
                [com setDrawLayer3:NO];
            else 
                [com setDrawLayer3:YES];
            break;
        case KEY_0:
            [com setDrawLayer1:YES];
            [com setDrawLayer2:YES];
            [com setDrawLayer3:YES];
            break;
        default:
            NSLog(@"Key pressed: %@", theEvent);
            break;
    }
}

-(void)MSG_openMap
{
    NSLog(@"load new map message");
    
    NSOpenPanel *op = [NSOpenPanel openPanel];
    NSString* filename;
    //[op setRequiredFileType:@"txt"];
    if ([op runModal] == NSOKButton)
    {
        filename = [op filename];
        
        const char* cfilename = [filename cStringUsingEncoding:NSASCIIStringEncoding];
        
        editor->delete_current_map();
        editor->loadMap(cfilename);
    }
    
    return;
    
}

-(void)MSG_startNew
{
    NSLog(@"load new map message");
        
    editor->delete_current_map();
    editor->loadMap(NULL);
    
    return;
}

-(void)MSG_resizeMap
{
    Communicator *com= [Communicator sharedCommunicator];
    
    int newRows = com.newRows;
    int newCols = com.newCols;
    
    editor->resizeMap(newRows, newCols);
}

-(void)MSG_saveMap
{
    NSSavePanel *sp = [NSSavePanel savePanel];
    NSString *filename;
    [sp setDirectory:@"/SavedMaps/"];
    [sp setRequiredFileType:@"txt"];
    if ([sp runModal] == NSOKButton)
    {
        filename = [sp filename];
        
        const char* cfilename = [filename cStringUsingEncoding:NSASCIIStringEncoding];
        
        editor->saveMap(cfilename);
    }
    
    return;
}

-(void)MSG_toggleWalkable
{
    Communicator *com = [Communicator sharedCommunicator];
    if (com.isInWalkableMode)
        editor->setWalkable(1);
    else
        editor->setWalkable(0);
}

-(void)dealloc
{
    [super dealloc];
    delete editor;

}

@end

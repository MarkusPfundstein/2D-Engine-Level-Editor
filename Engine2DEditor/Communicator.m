//
//  Communicator.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/18/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "Communicator.h"

@implementation Communicator

@synthesize tile_id;
@synthesize texPath;
@synthesize changeTile;
@synthesize objPath;

@synthesize onLayer;
@synthesize newRows;
@synthesize newCols;

@synthesize drawLayer1;
@synthesize drawLayer2;
@synthesize drawLayer3;

@synthesize activeTileImage;

@synthesize isInWalkableMode;

static Communicator *sharedCommunicator = nil;

+(Communicator*)sharedCommunicator
{
    @synchronized(self)
    {
        if (sharedCommunicator == nil)
        {
            sharedCommunicator = [[Communicator alloc]init];
            NSLog(@"Communicator alloc");
        }
    }
    
    return sharedCommunicator;
}

-(void)dealloc
{
    [activeTileImage release];
}

@end

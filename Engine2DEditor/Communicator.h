//
//  Communicator.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/18/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Communicator : NSObject
{
    bool changeTile;
    
    bool isInWalkableMode;

    const char *texPath;
    const char *objPath;
    
    int tile_id;
    
    int newCols;
    int newRows;
    
    bool drawLayer1;
    bool drawLayer2;
    bool drawLayer3;
    
    NSImage* activeTileImage;
}

@property (setter = setTileId: ) int tile_id;
@property (setter = setTexPath: )const char* texPath;
@property (setter = setChangeTile: )bool changeTile;
@property (setter = setObjPath: )const char* objPath;
@property (setter = setOnLayer: )int onLayer;
@property (setter = setNewCols: )int newCols;
@property (setter = setNewRows: )int newRows;
@property (setter = setDrawLayer1: )bool drawLayer1;
@property (setter = setDrawLayer2: )bool drawLayer2;
@property (setter = setDrawLayer3: )bool drawLayer3;
@property (setter = setIsInWalkableMode:)bool isInWalkableMode;
@property (nonatomic, retain, setter = setActiveTileImage:)NSImage* activeTileImage;


+(Communicator*)sharedCommunicator;

@end
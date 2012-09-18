//
//  TileWindow.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "TileWindow.h"
#import "Constants.h"
#import "Communicator.h"


#pragma mark -
#pragma mark SINGLE TILES CLASS
@interface SingleTile : NSObject
{
    NSImage* image;
    int _id;
}

@property (nonatomic, retain) NSImage *image;
@property int _id;

@end

@implementation SingleTile

@synthesize image;
@synthesize _id;

@end

#pragma mark -
#pragma mark TILEWINDOW

@interface TileWindow()
{
    NSMutableArray *arrayTiles;
    NSMutableArray *arrayObjects;
    int8_t layerObjectTiles;
}

@property (nonatomic, retain) NSMutableArray *arrayTiles;
@property (nonatomic, retain) NSMutableArray *arrayObjects;
@property int8_t layerObjectTiles;

@end

@implementation TileWindow

@synthesize arrayTiles;
@synthesize arrayObjects;
@synthesize matrix;
@synthesize objectMatrix;
@synthesize scrollView;
@synthesize scrollView2;
@synthesize comboBox;
@synthesize layerObjectTiles;

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived) name:@"newWorldLoaded" object:nil];
    
    matrix = [[NSMatrix alloc]initWithFrame:CGRectMake(10, 400, 200, 500) mode:NSRadioModeMatrix cellClass:[NSImageCell class] numberOfRows:NUMBER_SPRITES_TILESET numberOfColumns:NUMBER_SPRITES_TILESET];
    
    [matrix setCellSize:NSMakeSize(TILE_SIZE, TILE_SIZE)];
    [matrix sizeToCells];
    [matrix setTarget:self];
    [matrix setAction:@selector(MatrixPressed)];
    
    objectMatrix = [[NSMatrix alloc]initWithFrame:CGRectMake(0, 0, 300, 300) mode:NSRadioModeMatrix cellClass:[NSImageCell class] numberOfRows:NUMBER_SPRITES_TILESET numberOfColumns:NUMBER_SPRITES_TILESET];
    
    [objectMatrix setCellSize:NSMakeSize(TILE_SIZE, TILE_SIZE)];
    [objectMatrix sizeToCells];
    [objectMatrix setTarget:self];
    [objectMatrix setAction:@selector(objectMatrixPressed)];
    
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:YES];
    
    [self.scrollView setDocumentView:matrix];
    
    [self.scrollView2 setHasVerticalScroller:YES];
    [self.scrollView2 setHasHorizontalScroller:YES];
    
    [self.scrollView2 setDocumentView:objectMatrix];
    
    [self.comboBox setIntValue:1];
    self.layerObjectTiles = 1;
    [self.comboBox setTarget:self];
    [self.comboBox setAction:@selector(comboBoxPressed)];
    
    NSLog(@"TileWindow initialized");

}

#pragma mark -
#pragma mark General Methods

-(void)comboBoxPressed
{
    Communicator *com = [Communicator sharedCommunicator];
    self.layerObjectTiles = comboBox.intValue;
    [com setOnLayer:self.layerObjectTiles];
}

-(void)MatrixPressed
{
    Communicator *com = [Communicator sharedCommunicator];
    
    NSImageCell *temp = [matrix selectedCell];
    
    for (int i = 0; i < [self.arrayTiles count]; i++)
    {
        SingleTile *tempSingleTile = [self.arrayTiles objectAtIndex:i];
        if (tempSingleTile.image == temp.image)
        {
            [com setActiveTileImage:tempSingleTile.image];
            [com setTileId:tempSingleTile._id];
            [com setChangeTile:1];
            [com setOnLayer:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateActiveTileImage" object:nil];
        }
    }

}

-(void)objectMatrixPressed
{
    Communicator *com = [Communicator sharedCommunicator];
    
    NSImageCell *temp = [objectMatrix selectedCell];
    
    for (int i = 0; i < [self.arrayObjects count]; i++)
    {
        SingleTile *tempSingleTile = [self.arrayObjects objectAtIndex:i];
        if (tempSingleTile.image == temp.image)
        {
            [com setActiveTileImage:tempSingleTile.image];
            [com setTileId:tempSingleTile._id];
            [com setChangeTile:1];
            [com setOnLayer:self.layerObjectTiles]; 
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateActiveTileImage" object:nil];
        }
    }
}

-(void)loadTilesetWithFileName: (NSString*)filename inMatrix: (NSInteger) number
{
    NSImage* loadedTileset = [NSImage imageNamed:filename];

    int i;
    int j;
    int counter;
    counter = 0; // wow, this one was not initialized
    
    int numImages = NUMBER_SPRITES_TILESET;
    SingleTile *tiles[numImages*numImages];
    
    if (number == TILEMATRIX)
    {
        if (self.arrayTiles)
            [self.arrayTiles release], self.arrayTiles = nil;
        
        if (!self.arrayTiles)
            self.arrayTiles = [[NSMutableArray alloc]init];
    }
    else if (number == OBJECTMATRIX)
    {
        if (self.arrayObjects)
            [self.arrayObjects release], self.arrayObjects = nil;
        
        if (!self.arrayObjects)
            self.arrayObjects = [[NSMutableArray alloc]init];
    }
    
    // slicing loadedTileset into images[]
    for (i = numImages-1; i >= 0; i--)
    {
        for (j = 0; j < numImages; j++)
        {
            tiles[counter] = [[SingleTile alloc]init];
            tiles[counter].image = [[NSImage alloc]initWithSize:NSMakeSize(TILE_SIZE, TILE_SIZE)];
            [tiles[counter].image lockFocus];
            
            [loadedTileset drawInRect:NSMakeRect(-(j*TILE_SIZE),-(i*TILE_SIZE),TILE_SIZE*numImages,TILE_SIZE*numImages) fromRect:NSZeroRect
                            operation:NSCompositeCopy fraction:1.0f];
            
            [tiles[counter].image unlockFocus];
            tiles[counter]._id = counter;
            
            if (number == TILEMATRIX)
            {
                [self.arrayTiles addObject:tiles[counter]];
            
                NSImageCell *cell = (NSImageCell *)[matrix cellAtRow:numImages-i-1 column:j];
                [cell setImage:tiles[counter].image];
            }
            else if (number == OBJECTMATRIX)
            {
                [self.arrayObjects addObject:tiles[counter]];
                
                NSImageCell *cell = (NSImageCell *)[objectMatrix cellAtRow:numImages-i-1 column:j];
                [cell setImage:tiles[counter].image];
            }
            
            [tiles[counter] release];
            
            counter++;
        }
    }
    
}

-(void)messageReceived
{
    Communicator *com = [Communicator sharedCommunicator];
    
    NSString *nsPath = [NSString stringWithCString:com.texPath encoding:NSASCIIStringEncoding];
    NSString *objPath = [NSString stringWithCString:com.objPath encoding:NSASCIIStringEncoding];
    
    @synchronized(self)
    {
        if (nsPath)
        {
            NSLog(@"MSG REC: %@", nsPath);
            [self loadTilesetWithFileName:nsPath inMatrix:TILEMATRIX];
        }
        if (objPath)
        {
            NSLog(@"MSG REC: %@", objPath);
            [self loadTilesetWithFileName:objPath inMatrix:OBJECTMATRIX];
        }
    }
}

-(void)dealloc
{
    NSLog(@"dealloc TileWindow");

    [self.scrollView release];
    [self.matrix release];
    [self.arrayTiles release];
    [self.arrayObjects release];
    [self.comboBox release];
    
    [super dealloc];
}

@end

//
//  TileWindow.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TileWindow : NSView 
{
    NSMatrix *matrix;
    NSMatrix *objectMatrix;
    IBOutlet NSScrollView *scrollView;
    IBOutlet NSScrollView *scrollView2;
    IBOutlet NSComboBox *comboBox;
}

@property (nonatomic, retain) NSMatrix *matrix;
@property (nonatomic, retain) NSMatrix *objectMatrix;
@property (nonatomic, retain) IBOutlet NSScrollView *scrollView;
@property (nonatomic, retain) IBOutlet NSScrollView *scrollView2;
@property (nonatomic, retain) IBOutlet NSComboBox *comboBox;

-(void)loadTilesetWithFileName: (NSString*)filename inMatrix: (NSInteger) number;


@end

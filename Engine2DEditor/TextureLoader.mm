//
//  Texture2D.m
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "TextureLoader.h"

@implementation TextureLoader

@synthesize texture;
@synthesize width;
@synthesize height;

- (id)initWithFilename: (NSString*)filename
{
    NSString *seperator = @".";
    
    NSArray *split = [filename componentsSeparatedByString:seperator];
    
    self = [super init];
    if (self) {
    
        [self loadTextureFromPath:[split objectAtIndex:0] ofType:[split objectAtIndex:1]];
    }
    
    return self;
}

-(void)loadTextureFromPath:(NSString*)texPath ofType:(NSString*)type
{
    NSBitmapImageRep *image;
    unsigned char *imageData;
    
    image = [ NSBitmapImageRep imageRepWithContentsOfFile:[[NSBundle mainBundle]pathForResource:texPath ofType:type]];
    
    imageData = [image bitmapData];
    
    self.width = (GLuint)[image pixelsWide];
    self.height = (GLuint)[image pixelsHigh];
    
    // create opengl texture
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);   
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, imageData);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);


}

-(void)dealloc
{
    [super dealloc];
}


@end

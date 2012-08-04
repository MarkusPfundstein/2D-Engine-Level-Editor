//
//  Texture2D.cpp
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#include <iostream>
#include "TextureLoader.h"
#include "Texture2D.h"


Texture2D::Texture2D(char *filename)
{
    NSString *NSFilename = [NSString stringWithCString:filename encoding:[NSString defaultCStringEncoding]];
    
    TextureLoader* Texture = [[TextureLoader alloc] initWithFilename:NSFilename];
    
    this->texture = Texture.texture;
    this->width = Texture.width;
    this->height = Texture.height;
    
    [Texture release];
    
    printf("Texture %s loaded!\n", filename);
}
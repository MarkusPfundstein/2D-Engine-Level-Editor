//
//  Texture2D.h
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>


@interface TextureLoader : NSObject
{
    GLuint texture;
    GLuint width;
    GLuint height;
}

@property (nonatomic, setter=setTexture:) GLuint texture;
@property (nonatomic, setter=setWidth:) GLuint width;
@property (nonatomic, setter=setHeight:) GLuint height;

-(id)initWithFilename: (NSString*)filename;
-(void)loadTextureFromPath:(NSString*)texPath ofType:(NSString*)type;

@end

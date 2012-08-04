//
//  Texture2D.h
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#ifndef OpenGL_Texture2D_h
#define OpenGL_Texture2D_h

#import <OpenGL/gl.h>

class Texture2D
{
public:
    Texture2D(char*filename);
    
    GLuint texture;
    GLuint width;
    GLuint height;
    
    static void delete_texture(GLuint &tex)
    {
        glDeleteTextures(1, &tex);
    }
};

#endif

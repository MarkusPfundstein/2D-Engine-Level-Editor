//
//  Helpers.h
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#ifndef OpenGL_Helpers_h
#define OpenGL_Helpers_h

typedef struct {
    float x;
    float y;
} Point2D;

typedef struct {
    Point2D pos;
    float width;
    float height;
} Rect2D;

typedef struct {
    bool isWalkable;
    float x, y;
    u_int8_t tex_id;
    u_int8_t tex_id2;
    u_int8_t tex_id3;
} TILE;

extern const char* getPathFromBundle(const char *filename);
extern bool alertBoxYesNo(NSString* message); 

#endif

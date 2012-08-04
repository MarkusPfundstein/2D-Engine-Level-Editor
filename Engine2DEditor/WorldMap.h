//
//  WorldMap.h
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#ifndef OpenGL_WorldMap_h
#define OpenGL_WorldMap_h

#import <OpenGL/gl.h>

#include "Helpers.h"
#include "Constants.h"
#include "Texture2D.h"


class WorldMap
{
    TILE **tiles;
    
    int nRows;
    int nCols;
    
    GLuint vbo;
    GLuint texture;
    GLuint texture2;
    GLuint *tbo;
    
    int8_t numSprites;
    
    void parseLoadedFile(const char* filename);
    void create_buffers();
    void create_tbo(const GLfloat *texcoords, GLuint id);
    
    // EDITOR ONLY
    char textureFilename[20];
    char objectsFilename[20];
    
public:

    WorldMap(float map_width, float map_height);
    WorldMap(const char *filename);
    ~WorldMap();

    void draw(const Rect2D &viewpoint, bool walkingFieldsOn);
    void load_texture(char* filename);
    void create_empty_world();
    
    float get_world_width();
    float get_world_height();
    
    int getRows();
    int getCols();
    
    void changeTileId(int row, int col, int intoId, int onLayer);
    void toggleTileWalkable(int row, int col);
    
    const char* getTextureFilename();
    const char* getObjectsFilename();
    
    void resizeMap(int newRows, int newCols);
    
    void saveMap(const char* intoFilename);

};

#endif

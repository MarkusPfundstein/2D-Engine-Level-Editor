//
//  WorldMap.cpp
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#include <iostream>
#include <fstream>
using namespace std;
#include "Worldmap.h"
#include "Texture2D.h"
#include "Communicator.h"

WorldMap::WorldMap(float map_width, float map_height)
{
    this->nRows = map_width;
    this->nCols = map_height;
}

WorldMap::WorldMap(const char *filename)
{

    this->parseLoadedFile(filename);
}

WorldMap::~WorldMap()
{
    glDeleteBuffers(1, &this->vbo);
    glDeleteBuffers(numSprites*numSprites, this->tbo);
    glDeleteTextures(1, &this->texture);
    
    delete [] this->tbo;
    free (this->tiles);
    
    printf("Unloaded Map!\n");
}

void WorldMap::load_texture(char *filename)
{
    Texture2D *_texture = new Texture2D(filename);
    this->texture = _texture->texture;
    delete _texture;
}

void WorldMap::create_empty_world()
{
    int k;    
    // create 2d array for worldmap
    this->tiles = (TILE **) malloc(nRows *sizeof(TILE));
    
    for (k = 0; k < nRows; k++)
    {
        this->tiles[k] = (TILE *) malloc(nCols*sizeof(TILE));
    }
    
    float tempx;
    float tempy;
    
    for (int i = 0; i < nRows; i++)
    {
        for (int j = 0; j < nCols; j++)
        {
            tempx = (float)i*TILE_SIZE;
            tempy = (float)j*TILE_SIZE;
            
            this->tiles[i][j].x = tempx;
            this->tiles[i][j].y = tempy;
            
            this->tiles[i][j].tex_id = 6;
            
            this->tiles[i][j].isWalkable = 0;
        }
    }
    
    this->create_buffers();
}

void WorldMap::parseLoadedFile(const char *filename)
{
    // editor load path
    const char* path = filename;
    
    ifstream inputFile;
    inputFile.open(path);
    
    // for parsing
    long lengthInputFile = inputFile.tellg();
    inputFile.seekg(0, ios::beg);
    char *buffer = new char[sizeof(lengthInputFile)];
    
    // variables we will use to store our values
    char *textureToLoad = new char[30];
    
    int _rows;
    int _cols;
    
    printf("Worldmap with Name: %s opened\n", filename);
    
    inputFile >> buffer;
    strcpy(textureToLoad, buffer);
    printf("%s\n", textureToLoad);
    
    strcpy(this->textureFilename, textureToLoad);
    
    // layer_tiles1 finished with loading, load objects layer1
    char *objectTexToLoad = new char[30];
    
    inputFile >> buffer;
    strcpy(objectTexToLoad, buffer);
    printf("ObjectToLoad: %s\n", objectTexToLoad);
    
    strcpy(this->objectsFilename, objectTexToLoad);
    
    inputFile >> buffer;
    _rows = atoi(buffer);
    printf("%d\n", _rows);
    
    inputFile >> buffer;
    _cols = atoi(buffer);
    printf("%d\n", _cols);
    
    Texture2D *tileset = new Texture2D(textureToLoad);
    this->texture = tileset->texture;
    
    Texture2D *tileset2 = new Texture2D(objectTexToLoad);
    this->texture2 = tileset2->texture;
    
    this->nRows = _rows;
    this->nCols = _cols;
    
    int k;    
    // create 2d array for worldmap
    this->tiles = (TILE **) malloc(nRows *sizeof(TILE));
    
    for (k = 0; k < nRows; k++)
    {
        this->tiles[k] = (TILE *) malloc(nCols*sizeof(TILE));
    }
    
    float tempx;
    float tempy;
    
    for (int i = 0; i < nRows; i++)
    {
        for (int j = 0; j < nCols; j++)
        {
            tempx = (float)i*TILE_SIZE;
            tempy = (float)j*TILE_SIZE;
            
            this->tiles[i][j].x = tempx;
            this->tiles[i][j].y = tempy;
            
            inputFile >> buffer;
            this->tiles[i][j].tex_id = atoi(buffer);
            inputFile >> buffer;
            this->tiles[i][j].tex_id2 = atoi(buffer);
            inputFile >> buffer;
            this->tiles[i][j].tex_id3 = atoi(buffer);
            inputFile >> buffer;
            this->tiles[i][j].isWalkable = atoi(buffer);
        }
    }

    
    // world loaded, now we create vbos and tbos
    this->create_buffers();
    
    delete [] objectTexToLoad;
    delete [] textureToLoad;
    delete [] buffer;
    delete tileset;
    delete tileset2;
    
    inputFile.close();
}


void WorldMap::draw(const Rect2D& viewpoint, bool walkingFieldsOn)
{
    Communicator *com = [Communicator sharedCommunicator];
    
    glBindBuffer(GL_ARRAY_BUFFER, this->vbo);
    glVertexPointer(3, GL_FLOAT, 0, (char*)NULL);
    
    int m;
    int n;
    
    if (viewpoint.pos.x > viewpoint.width)
        m = (float)viewpoint.pos.x / TILE_SIZE;
    else
        m= 0;
        
    float temp = viewpoint.pos.y;
    
    if (temp > viewpoint.height)
        n = (float)temp / TILE_SIZE;
    else
        n = 0;
    
    int i2 = ((viewpoint.pos.x + viewpoint.width) / TILE_SIZE)+1;
    int j2 = ((temp + viewpoint.height) / TILE_SIZE)+1;
    
    if (i2 > nRows)
        i2 = nRows;
    if (j2 > nCols)
        j2 = nCols;
    
    for (int i = m; i < i2; i++)
    {
        for (int j = n; j < j2; j++)
        {
            //printf("draw!");
            glPushMatrix();
            
            glTranslatef(this->tiles[i][j].x, this->tiles[i][j].y, 0.0f);
            
            // EDITOR ONLY 
            if (walkingFieldsOn)
            {
                if (this->tiles[i][j].isWalkable)
                {
                    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                }
                else
                {
                    glColor4f(1.0f, 0.0f, 0.0f, 0.5f);
                }
            }
            else
                glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
            
            if (com.drawLayer1)
            {
                // draw first layer
                glBindTexture(GL_TEXTURE_2D, this->texture);
                glBindBuffer(GL_ARRAY_BUFFER, this->tbo[this->tiles[i][j].tex_id]);
                glTexCoordPointer(2, GL_FLOAT, 0, (void*)NULL);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);
            }
            
            glBindTexture(GL_TEXTURE_2D, this->texture2);
            if (com.drawLayer2)
            {
                // draw second layer

                glBindBuffer(GL_ARRAY_BUFFER, this->tbo[this->tiles[i][j].tex_id2]);
                glTexCoordPointer(2, GL_FLOAT, 0, (void*)NULL);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);
            }
            // 
            // here we would draw player
            // 
            if (com.drawLayer3)
            {
                // draw third with same texture as second layer
                glBindBuffer(GL_ARRAY_BUFFER, this->tbo[this->tiles[i][j].tex_id3]);
                glTexCoordPointer(2, GL_FLOAT, 0, (void*)NULL);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);
            }
            
            glPopMatrix();
        }
    }
}

void WorldMap::create_buffers()
{
    const GLfloat vertices[] = {
        TILE_SIZE, 0, 0,
        0, 0, 0,
        0, TILE_SIZE, 0, 
        0, TILE_SIZE, 0,
        TILE_SIZE, TILE_SIZE, 0,
        TILE_SIZE, 0, 0,
        
    };
    
    glGenBuffers(1, &this->vbo);
    glBindBuffer(GL_ARRAY_BUFFER, this->vbo);
    glBufferData(GL_ARRAY_BUFFER, 54*sizeof(GLfloat), vertices, GL_STATIC_DRAW);
    
    // create texture buffers, 1 for each animationstep
    
    numSprites = NUMBER_SPRITES_TILESET;
    this->tbo = new GLuint[numSprites*numSprites];
    
    
    Point2D *point = new Point2D[6];
    Rect2D offset;
    GLfloat *texcoords = new GLfloat[12];;
    
    int counter = 0;
    int nSpriteCol = 0;
    int nSpriteRow = 0;
    
    for (int i = 0; i < numSprites; i++)
    {
        for (int j = 0; j < numSprites; j++)
        {
            offset.pos.x = (float)nSpriteCol/numSprites;                           
            offset.pos.y = (float)nSpriteRow/numSprites;
            offset.width = (float)1/numSprites;              
            offset.height = (float)1/numSprites;             
            
            point[0].x = offset.pos.x + offset.width;
            point[0].y = offset.pos.y;
            point[1].x = offset.pos.x;
            point[1].y = offset.pos.y;
            point[2].x = offset.pos.x;
            point[2].y = offset.pos.y + offset.height;
            point[3].x = point[2].x;
            point[3].y = point[2].y;
            point[4].x = point[1].x + offset.width;
            point[4].y = point[1].y + offset.height;
            point[5].x = point[0].x;
            point[5].y = point[0].y;
            
            for (int k = 0, l = 0; l < 6; k += 2, l++) 
            {
                texcoords[k] = point[l].x;
                texcoords[k+1] = point[l].y;
            }
            
            this->create_tbo(texcoords, counter);
            
            nSpriteCol++;
            counter++;
        }
        nSpriteRow++;
    }
    
    delete[] point;
    delete[] texcoords;
}


void WorldMap::create_tbo(const GLfloat *texcoords, GLuint id)
{
    glGenBuffers(1, &this->tbo[id]);
    glBindBuffer(GL_ARRAY_BUFFER, this->tbo[id]);
    glBufferData(GL_ARRAY_BUFFER, 24*sizeof(GLfloat), texcoords, GL_STATIC_DRAW);
}

float WorldMap::get_world_width()
{
    return this->nRows*TILE_SIZE;
}

float WorldMap::get_world_height()
{
    return this->nCols*TILE_SIZE;
}

int WorldMap::getRows()
{
    return this->nRows;
}

int WorldMap::getCols()
{
    return this->nCols;
}

void WorldMap::changeTileId(int row, int col, int intoId, int onLayer)
{
    if (row < 0 || row > nRows-1 || col < 0 || col > nCols-1)
        return;
    
    if (onLayer==0)
    {
        this->tiles[row][col].tex_id = intoId;
    }
    else if (onLayer==1)
    {
        this->tiles[row][col].tex_id2 = intoId;
    }
    else if (onLayer==2)
    {
        this->tiles[row][col].tex_id3 = intoId;
    }
}

void WorldMap::toggleTileWalkable(int row, int col)
{
    if (row < 0 || row > nRows-1 || col < 0 || col > nCols-1)
        return;
    
    if (this->tiles[row][col].isWalkable)
        this->tiles[row][col].isWalkable = false;
    else
        this->tiles[row][col].isWalkable = true;
}

const char* WorldMap::getTextureFilename()
{
    return this->textureFilename;
}

const char* WorldMap::getObjectsFilename()
{
    return this->objectsFilename;
}

void WorldMap::resizeMap(int newRows, int newCols)
{
    printf("RESIZE MAP to Rows: %d, Cols: %d\n", newRows, newCols);
    
    int k;    
    int i;
    int j;
    
    // create 2d array for temp 
    TILE **tempTiles = (TILE **) malloc(nRows *sizeof(TILE));
    
    for (k = 0; k < nRows; k++)
    {
        tempTiles[k] = (TILE *) malloc(nCols*sizeof(TILE));
    }
    
    // copy original tiles in tempTiles
    for (i = 0; i < this->nRows; i++)
    {
        for (j = 0; j < this->nCols; j++)
        {
            tempTiles[i][j].isWalkable = this->tiles[i][j].isWalkable;
            tempTiles[i][j].x = this->tiles[i][j].x;
            tempTiles[i][j].y = this->tiles[i][j].y;
            tempTiles[i][j].tex_id = this->tiles[i][j].tex_id;
            tempTiles[i][j].tex_id2 = this->tiles[i][j].tex_id2;
            tempTiles[i][j].tex_id3 = this->tiles[i][j].tex_id3;
        }
    }
    
    // create new 2d array for worldmap
    this->tiles = (TILE **) realloc(NULL, newRows *sizeof(TILE));
    
    for (k = 0; k < newRows; k++)
    {
        this->tiles[k] = (TILE *) realloc(NULL, newCols*sizeof(TILE));
    }
    
    float tempx;
    float tempy;
    
    if (newRows <= this->nRows)
        this->nRows = newRows;
    if (newCols <= this->nCols)
        this->nCols = newCols;
    
    // write into new memory
    for (i = 0; i < newRows; i++)
    {
        for (j = 0; j < newCols; j++)
        {
            tempx = (float)i*TILE_SIZE;
            tempy = (float)j*TILE_SIZE;
            
            this->tiles[i][j].x = tempx;
            this->tiles[i][j].y = tempy;
            this->tiles[i][j].tex_id = 0;
            this->tiles[i][j].tex_id2 = 255;
            this->tiles[i][j].tex_id3 = 255;
            this->tiles[i][j].isWalkable = 1;
        }
    }
    
    for (i = 0; i < this->nRows; i++)
    {
        for (j = 0; j < this->nCols; j++)
        {
            this->tiles[i][j].x = tempTiles[i][j].x;
            this->tiles[i][j].y = tempTiles[i][j].y;
            this->tiles[i][j].tex_id = tempTiles[i][j].tex_id;
            this->tiles[i][j].tex_id2 = tempTiles[i][j].tex_id2;
            this->tiles[i][j].tex_id3 = tempTiles[i][j].tex_id3;
            this->tiles[i][j].isWalkable = tempTiles[i][j].isWalkable;
        }
    }
    
    this->nRows = newRows;
    this->nCols = newCols;
    
    free(tempTiles);
}

void WorldMap::saveMap(const char *intoFilename)
{
    const char* path = intoFilename;
    
    ofstream outputFile;
    outputFile.open(path);
    
    if (!outputFile.is_open())
    {
        printf("Error opening savefile\n");
        return;
    }
    
    outputFile << this->textureFilename << " ";
    outputFile << this->objectsFilename << " ";
    outputFile << this->nRows << " ";
    outputFile << this->nCols << " ";
    
    char temp[4];
    
    for (int i = 0; i < this->nRows; i++)
    {
        for (int j = 0; j < this->nCols; j++)
        {
            sprintf(temp, "%d", this->tiles[i][j].tex_id);
            outputFile << temp << " ";
            sprintf(temp, "%d", this->tiles[i][j].tex_id2);
            outputFile << temp << " ";
            sprintf(temp, "%d", this->tiles[i][j].tex_id3);
            outputFile << temp << " ";
            sprintf(temp, "%d", this->tiles[i][j].isWalkable);
            outputFile << temp << " ";
        }
    }
    
    printf("File saved into: %s, ", path);
    outputFile.close();
}
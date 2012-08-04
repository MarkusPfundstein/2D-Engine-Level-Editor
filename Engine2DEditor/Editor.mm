//
//  Editor.c
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#include <stdio.h>
#include <OpenGL/gl.h>
#include <Cocoa/Cocoa.h>
#include "Editor.h"
#include "Constants.h"
#include "Communicator.h"

Editor::Editor()
{
    camera.pos.x = 0.0f;
    camera.pos.y = 0.0f;
    camera.width = SCREEN_WIDTH_EDITOR;
    camera.height = SCREEN_HEIGHT_EDITOR;
    
    this->walkableMode = false;
}

Editor::~Editor()
{
    delete this->current_world;
}

void Editor::initScene()
{
    glEnable(GL_TEXTURE_2D);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    this->loadMap(NULL);
    this->updateScene();
}

void Editor::updateScene()
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(camera.pos.x, camera.pos.x+camera.width, camera.pos.y+camera.height, camera.pos.y, -1.0f, 1.0f);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    this->drawScene();
}

void Editor::drawScene()
{
    this->current_world->draw(camera, this->walkableMode);
    
    this->drawGrid(this->current_world->getRows(),this->current_world->getCols());
    
    glFlush();
}

void Editor::drawGrid(float _screen_width, float _screen_height)
{
    float start_x, end_x;
    float start_y, end_y;
    int i;
    
    glColor4f(0.5f, 0.5f, 0.5f, 1.0f);
    
    glBegin(GL_LINES);
    for (i = 0; i < _screen_width; i++)
    {
        start_x = 0.0f;
        end_x = _screen_width*TILE_SIZE;
        
        start_y = i*TILE_SIZE;
        end_y = start_y;
        
        glVertex2f(start_x, start_y);
        glVertex2f(end_x, end_y);
    }
    for (i = 0; i < _screen_height; i++)
    {
        start_x = i*TILE_SIZE;
        end_x = start_x;
        
        start_y = 0.0f;
        end_y = _screen_height*TILE_SIZE;
        glVertex2f(start_x, start_y);
        glVertex2f(end_x, end_y);
    }
    glEnd();
}

void Editor::centerCameraAt(const Point2D toPoint)
{
    camera.pos.x = toPoint.x-SCREEN_WIDTH_EDITOR/2;
    camera.pos.y = toPoint.y-SCREEN_HEIGHT_EDITOR/2;
}

void Editor::moveCameraWith(float velo_x, float velo_y)
{
    camera.pos.x += velo_x;
    camera.pos.y -= velo_y;
}

void Editor::scrollMap(int direction, int scrollSpeed)
{
    switch (direction)
    {
        case UP:
            
            camera.pos.y -= scrollSpeed;
            
            break;
        case RIGHT:
            
            camera.pos.x += scrollSpeed;
            
            break;
        case LEFT:
            
            camera.pos.x -= scrollSpeed;
            
            break;
        case DOWN:
            
            camera.pos.y += scrollSpeed;
            
            break;
    }
}

void Editor::loadMap(const char *filename)
{
    if (filename == NULL)
    {
        this->current_world = new WorldMap(getPathFromBundle((char*)"init_map.txt"));
    }
    else
    {
        this->current_world = new WorldMap(filename);
    }
    
    // notify TileWindow about the new World
    Communicator *com = [Communicator sharedCommunicator];
    [com setTexPath:this->current_world->getTextureFilename()];
    [com setObjPath:this->current_world->getObjectsFilename()];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"newWorldLoaded" object:nil];
    
    this->camera.pos.x = 0.0f;
    this->camera.pos.y = 0.0f;
}

void Editor::saveMap(const char *filename)
{
    this->current_world->saveMap(filename);
}

void Editor::delete_current_map()
{
    delete this->current_world;
}

void Editor::changeTileAt(float _x, float _y, int intoId, int onLayer)
{
    if (!this->walkableMode)
    {
        float rowToChangef = (camera.pos.x+_x)/TILE_SIZE;
        float colToChangef = (camera.pos.y+SCREEN_HEIGHT_EDITOR-_y)/TILE_SIZE;
        
        int rowToChange = (int)rowToChangef;
        int colToChange = (int)colToChangef;
        
        this->current_world->changeTileId(rowToChange, colToChange, intoId, onLayer);
    }
}

void Editor::changeTileWalkableAt(float _x, float _y)
{
    if (this->walkableMode)
    {
        float rowToChangef = (camera.pos.x+_x)/TILE_SIZE;
        float colToChangef = (camera.pos.y+SCREEN_HEIGHT_EDITOR-_y)/TILE_SIZE;
        
        int rowToChange = (int)rowToChangef;
        int colToChange = (int)colToChangef;
        
        this->current_world->toggleTileWalkable(rowToChange, colToChange);
    }
}

void Editor::toggleWalkable()
{
    if (this->walkableMode)
        this->walkableMode = false;
    else
        this->walkableMode = true;
}

void Editor::setWalkable(bool _value)
{
    this->walkableMode = _value;
}

void Editor::resizeMap(int newRows, int newCols)
{
    this->current_world->resizeMap(newRows, newCols);
    this->camera.pos.x = 0.0f;
    this->camera.pos.y = 0.0f;
}
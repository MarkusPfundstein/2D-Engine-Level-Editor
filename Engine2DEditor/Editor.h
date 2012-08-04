//
//  Editor.h
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/17/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#ifndef Engine2DEditor_Editor_h
#define Engine2DEditor_Editor_h

#include "Helpers.h"
#include "WorldMap.h"

class Editor
{
private:
    Rect2D camera;
    WorldMap *current_world;
    
    void drawGrid(float _screen_width, float _screen_height);
    
    bool walkableMode;
    
public:
    Editor();
    ~Editor();
    
    void initScene();
    void updateScene();
    void drawScene();
    
    void centerCameraAt(const Point2D toPoint);
    void moveCameraWith(float velo_x, float velo_y);
    void scrollMap(int direction, int scrollSpeed);
    void loadMap(const char* filename);
    void saveMap(const char* filename);
    void changeTileAt(float _x, float _y, int intoId, int onLayer);
    void changeTileWalkableAt(float _x, float _y);
    void delete_current_map();
    void setWalkable(bool _value);
    void toggleWalkable();
    void resizeMap(int newRows, int newCols);
    
};

#endif

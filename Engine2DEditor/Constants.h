//
//  Constants.h
//  OpenGL
//
//  Created by Markus Pfundstein on 9/10/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#ifndef OpenGL_Constants_h
#define OpenGL_Constants_h

// For Notification Center


// Screen Resolutions for iPhone/iPad
#define SCREEN_WIDTH_EDITOR    800
#define SCREEN_HEIGHT_EDITOR   600

#define NUMBER_SPRITES_TILESET 16

#define TILE_SIZE              32
#define NO_TILE_ID             255

enum ViewDirection {
    DOWN = 0,
    LEFT,
    RIGHT,
    UP
};

enum Layers {
    LAYER_1 = 0,
    LAYER_2,
    LAYER_3
};

enum keyCodes {
    KEY_W = 13,
    KEY_1 = 18,
    KEY_2 = 19,
    KEY_3 = 20,
    KEY_7 = 26,
    KEY_8 = 28,
    KEY_9 = 25,
    KEY_0 = 29,
    KEY_ESC = 53,
    KEY_LEFT = 123,
    KEY_RIGHT,
    KEY_DOWN,
    KEY_UP
};

enum TileWindow_Matrix {
    TILEMATRIX = 0,
    OBJECTMATRIX = 1
};

#endif

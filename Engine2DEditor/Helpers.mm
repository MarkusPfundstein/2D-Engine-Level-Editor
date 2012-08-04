//
//  Helpers.cpp
//  Engine2D
//
//  Created by Markus Pfundstein on 9/16/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#include <iostream>
#include "Helpers.h"

// returns c string of a file located on mainBundle of the App
const char* getPathFromBundle(const char *filename)
{
    NSString *NSFilename = [NSString stringWithCString:filename encoding:[NSString defaultCStringEncoding]];
    
    NSString *seperator = @".";
    
    NSArray *split = [NSFilename componentsSeparatedByString:seperator];
    
    NSString *NSPath = [[NSBundle mainBundle] pathForResource:[split objectAtIndex:0] ofType:[split objectAtIndex:1]];
    
    return [NSPath UTF8String];
}

bool alertBoxYesNo(NSString* message)
{
    NSAlert *alertView = [NSAlert alertWithMessageText:@"Watch out!" defaultButton:@"YES" alternateButton:@"NO" otherButton:nil informativeTextWithFormat:message];
    
    if ([alertView runModal] == NSOKButton)
        return true;
    
    return false;
}
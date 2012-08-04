//
//  MainMenu.m
//  Engine2DEditor
//
//  Created by Markus Pfundstein on 9/18/11.
//  Copyright 2011 The Saints. All rights reserved.
//

#import "MainMenu.h"
#import "Constants.h"
#import "Helpers.h"

@implementation MainMenu

- (void)awakeFromNib
{
    NSLog(@"MainMenu loaded");
}

- (IBAction)openMap:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menu_load_new_map" object:nil];
}

- (IBAction)newMap:(id)sender
{
    if (alertBoxYesNo(@"Do you really want to start a new map? All not saved data will be lost forever!!!!"))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menu_start_new_map" object:nil];
    }
}

-(IBAction)saveMap:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menu_save_map" object:nil];
}

@end

//
//  IKBBrowserItem.h
//  IKBrowserViewDND
//
//  Created by David Gohara on 2/26/08.
//  Copyright 2008 SmackFu-Master. All rights reserved.
//  http://smackfumaster.com
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface IKBBrowserItem : NSObject 
{

	NSImage * image;
	NSString * imageID;
	
}

- (id)initWithImage:(NSImage *)image imageID:(NSString *)imageID;

@property(readwrite,copy) NSImage * image;
@property(readwrite,copy) NSString * imageID;

#pragma mark -
#pragma mark Required Methods IKImageBrowserItem Informal Protocol
- (NSString *) imageUID;
- (NSString *) imageRepresentationType;
- (id) imageRepresentation;

#pragma mark -
#pragma mark Optional Methods IKImageBrowserItem Informal Protocol
- (NSString*) imageTitle;

@end

//
//  Output.m
//  CoreAudioTest
//
//  Created by Josep on 30/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Output.h"


@implementation Output{
    
}


- (id) init{
    self = [super initWithNumUnits:1];
    [self setEnabled:true];
    [self create];
    return self;
}

- (void) create{
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_DefaultOutput;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;

    // Get the default playback output unit
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output");

    // Create a new unit based on this that we'll use for output
    OSErr err = AudioComponentInstanceNew(defaultOutput, &(audioUnits[0]));
    NSAssert1(audioUnits[0], @"Error creating unit: %hd", err);
}

- (void) start{
    OSErr err = AudioOutputUnitStart(audioUnits[0]);
    NSAssert1(err == noErr, @"Error starting output unit: %hd", err);
}

- (void) stop{
    OSErr err = AudioOutputUnitStop(audioUnits[0]);
    NSAssert1(err == noErr, @"Error stopping output unit: %hd", err);
    
}

@end
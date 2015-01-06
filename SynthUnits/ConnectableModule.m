//
//  ConnectableModule.m
//  CoreAudioTest
//
//  Created by Josep on 30/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectableModule.h"


@implementation ConnectableAudioModule {
}

- (id) initConnectableWithNumUnits : (int) numUnits{
    self = [super initWithNumUnits: numUnits];
    return self;
}

- (void) connectTo: (BaseAudioModule*) module FromBus: (uint)outBus ToBus: (uint)inBus{
    
    AudioUnitConnection connection;
    connection.sourceAudioUnit = [ self getOutUnit ];
    connection.sourceOutputNumber = outBus;
    connection.destInputNumber = inBus;
    
    OSErr setupErr = AudioUnitSetProperty([module getInUnit],
                                          kAudioUnitProperty_MakeConnection, kAudioUnitScope_Input, inBus,
                                          &connection, sizeof(connection));
    
    
    NSAssert1(setupErr == noErr, @"Error making connection: %hd", setupErr);
    
}

@end
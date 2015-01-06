//
//  Mixer.m
//  CoreAudioTest
//
//  Created by Josep on 16/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mixer.h"



@implementation Mixer{
    int _numberBuses;
}


- (id) init{
    self = [super initConnectableWithNumUnits:1];
    _numberBuses = 2; // only two buses accepted for now, if more are needed we should add more splitters
    [self create];
    [self initVolumes];
    return self;
}

-(void) create{
    
    AudioComponentDescription componentDesc;
    componentDesc.componentType = kAudioUnitType_Mixer;
    componentDesc.componentSubType = kAudioUnitSubType_StereoMixer;
    componentDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    componentDesc.componentFlags = 0;
    componentDesc.componentFlagsMask = 0;
 
    AudioComponent mixerComponent = AudioComponentFindNext(NULL, &componentDesc);
    NSAssert(mixerComponent, @"Can't find a filter");
    
    OSErr err = AudioComponentInstanceNew(mixerComponent, &(audioUnits[0]));
    NSAssert1((audioUnits[0]), @"Error creating filter unit: %hd", err);
    
    
    UInt32  size        = sizeof(UInt32);
    UInt32  busCount    = _numberBuses;
    
    err = AudioUnitSetProperty ( audioUnits[0],
                                  kAudioUnitProperty_BusCount,
                                  kAudioUnitScope_Input,
                                  0,
                                  &busCount,
                                  size);
    NSAssert1(err == noErr, @"Error setting number of buses: %hd", err);
    
    
    //[self setStreamFormatFromBus:0 toBus:_numberBuses-1 forInput:true];
    //[self setStreamFormatFromBus:0 toBus:0 forInput:false];
    
}

-(void) initVolumes {
    
    for (int i = 0; i < _numberBuses; i++) {
        [self setInputVolume:1.0 onBus:i];
    }
    [self setOutputVolume:1.0];
    
}


-(void) setInputVolume: (float)volume onBus: (int)bus {
    
    OSErr err = AudioUnitSetParameter((audioUnits[0]),
                                kMultiChannelMixerParam_Volume,
                                kAudioUnitScope_Input,
                                bus,
                                volume,
                                0);
    NSAssert1(err == noErr, @"Could not set volume on mixer unit: %hd", err);

}

-(void) setOutputVolume: (float)volume {
    
    OSErr err = AudioUnitSetParameter((audioUnits[0]),
                                      kMultiChannelMixerParam_Volume,
                                      kAudioUnitScope_Output,
                                      0,
                                      volume,
                                      0);
    NSAssert1(err == noErr, @"Could not set volume on mixer unit: %hd", err);
}



@end

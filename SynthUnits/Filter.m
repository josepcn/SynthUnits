//
//  Filter.m
//  CoreAudioTest
//
//  Created by Josep on 12/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Filter.h"

@implementation Filter{
    FilterType _type;
    double _lowCutOffFreq;
    double _highCutOffFreq;
}


-(id) init{
    self = [super initConnectableWithNumUnits:1];
    _type = kLowPass;
    _lowCutOffFreq = 0;
    _highCutOffFreq = 0;
    [self create];
    [self setEnabled:true];
    return self;
}

-(id) initWithType : (FilterType) type{
    self = [super initConnectableWithNumUnits:1];
    _type = type;
    _lowCutOffFreq = 0;
    _highCutOffFreq = 0;
    [self create];
    [self setEnabled:true];
    return self;
}

-(OSType) getTypeAsOSType{
    OSType t;

    if( _type == kLowPass ){
        t = kAudioUnitSubType_LowPassFilter;
    }else if( _type == kHighPass ){
        t = kAudioUnitSubType_HighPassFilter;
    }else if( _type == kBandPass ){
        t = kAudioUnitSubType_BandPassFilter;
    }
    return t;
}

-(void) create{
    
    AudioComponentDescription filterDescription;
    filterDescription.componentType = kAudioUnitType_Effect;
    filterDescription.componentSubType = [self getTypeAsOSType];
    filterDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    filterDescription.componentFlags = 0;
    filterDescription.componentFlagsMask = 0;
    
    AudioComponent generatorComponent = AudioComponentFindNext(NULL, &filterDescription);
    NSAssert(generatorComponent, @"Can't find a filter");
    
    OSErr err = AudioComponentInstanceNew(generatorComponent, &(audioUnits[0]));
    NSAssert1((audioUnits[0]), @"Error creating filter unit: %hd", err);
    
    
    // Global, Hz, 10->(SampleRate/2), 6900
    //kLowPassParam_CutoffFrequency 			= 0,
    /*
    err = AudioUnitSetParameter((audioUnits[0]),
                          kLowPassParam_CutoffFrequency,
                          kAudioUnitScope_Global,
                          0,
                          1000,
                          0);
    NSAssert1(err == noErr, @"Error setting property for filter: %hd", err);
    */
    // Global, dB, -20->40, 0
    //kLowPassParam_Resonance 				= 1
    /*err = AudioUnitSetParameter((audioUnits[0]),
                                kLowPassParam_Resonance,
                                kAudioUnitScope_Global,
                                0,
                                0,
                                0);
    NSAssert1(err == noErr, @"Error setting property for filter: %hd", err);
     */
    
    
}
-(void) setCutOffFreqTo : (double) freq{

    OSErr err = AudioUnitSetParameter((audioUnits[0]),
                      kLowPassParam_CutoffFrequency,
                      kAudioUnitScope_Global,
                      0,
                      freq,
                      0);
    NSAssert1(err == noErr, @"Error setting cutoff for filter: %hd", err);
}


-(void) setEnabled : (bool) enabled{
    [super setEnabled:enabled];
    
    if( enabled ){
        [self setCutOffFreqTo:_highCutOffFreq];
    }
    else{
        double maxCutOffFreq = defaultSampleRate/2.0;
        [self setCutOffFreqTo:maxCutOffFreq];
    }
}

-(void) setLowCutOffFreq : (double)lowCutOffFreq{
    _lowCutOffFreq = lowCutOffFreq;
    [self setCutOffFreqTo:_lowCutOffFreq];

}

-(void) setHighCutOffFreq: (double)highCutOffFreq{
    _highCutOffFreq = highCutOffFreq;
    //[self setCutOffFreqTo:highCutOffFreq];

    
}


@end
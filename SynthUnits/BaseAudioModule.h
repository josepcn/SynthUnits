//
//  BaseAudioModule.h
//  CoreAudioTest
//
//  Created by Josep on 6/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#ifndef CoreAudioTest_BaseAudioModule_h
#define CoreAudioTest_BaseAudioModule_h


#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>

static const double defaultSampleRate = 44100;
static const double defaultFrequency  = 440;
static const double defaultAmplitude = 0.25;

// https://developer.apple.com/library/mac/documentation/MusicAudio/Conceptual/CoreAudioOverview/SystemAudioUnits/SystemAudioUnits.html

@interface BaseAudioModule : NSObject{
    AudioComponentInstance * audioUnits; // array
}

- (id) initWithNumUnits : (int) numUnits;
- (void) initializeUnits;

- (AudioComponentInstance) getInUnit;
- (AudioComponentInstance) getOutUnit;

- (bool) isEnabled;
- (void) setEnabled : (bool) enabled;

//+ (void) checkStreamFormatOnBus : (UInt32) busIni forInput:(bool) isInput onUnit:(AudioComponentInstance) unit;
//- (void) checkStreamFormatOnBus : (UInt32) busIni forInput:(bool) isInput;

+ (void) setStreamFormatFromBus : (UInt32) busIni toBus: (UInt32) busEnd forInput:(bool) isInput onUnit:(AudioComponentInstance) unit;
//- (void) setStreamFormatFromBus : (UInt32) busIni toBus: (UInt32) busEnd forInput:(bool) isInput;



@end

#endif

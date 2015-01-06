//
//  BaseAudioModule.m
//  CoreAudioTest
//
//  Created by Josep on 6/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAudioModule.h"
//#import "../CoreAudioUtilityClasses/CoreAudio/PublicUtility/CAStreamBasicDescription.h"


@implementation BaseAudioModule{
    int _numAudioUnits;
    bool _enabled;
}

    - (id) initWithNumUnits : (int) numUnits {
        _numAudioUnits = numUnits;
        audioUnits = (AudioComponentInstance*)malloc(sizeof(AudioComponentInstance) * _numAudioUnits);
        return self;
    }

    - (AudioComponentInstance) getInUnit{
        return audioUnits[0];
    }
    - (AudioComponentInstance) getOutUnit{
        return audioUnits[_numAudioUnits-1];
    }

    -(bool) isEnabled{
        return _enabled;
    }
    -(void) setEnabled : (bool) enabled{
        _enabled = enabled;
    }

    - (void) initializeUnits{
        
        for( int i = 0; i < _numAudioUnits; i++ ){
            OSErr err = AudioUnitInitialize(audioUnits[i]);
            NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
        }
    }

    + (void) checkStreamFormatOnBus : (UInt32) bus forInput:(bool) isInput onUnit:(AudioComponentInstance) unit{
        UInt32 scope = kAudioUnitScope_Input;
        if( isInput == false ){
            scope = kAudioUnitScope_Output;
        }
        
        
        // Get a CAStreamBasicDescription from the mixer bus.
        AudioStreamBasicDescription desc;
        UInt32 size = sizeof(desc);
        OSErr result = AudioUnitGetProperty( unit,
                                            kAudioUnitProperty_StreamFormat,
                                            scope,
                                            bus,
                                            &desc,
                                            &size);
        NSAssert1(result == noErr, @"Error getting stream format: %hd", result);
        
        //printf("checked: "); desc.Print();

    }

/*

    + (void) setStreamFormatFromBus : (UInt32) busIni toBus: (UInt32) busEnd forInput:(bool) isInput onUnit:(AudioComponentInstance) audioUnit{
       
        
        UInt32 scope = kAudioUnitScope_Input;
        if( isInput == false ){
            scope = kAudioUnitScope_Output;
        }
        
        for( UInt32 bus = busIni; bus <= busEnd; bus++ ){
            
            // Get a CAStreamBasicDescription from the mixer bus.
            AudioStreamBasicDescription desc;
            UInt32 size = sizeof(desc);
            OSErr result = AudioUnitGetProperty( audioUnit,
                                                kAudioUnitProperty_StreamFormat,
                                                scope,
                                                bus,
                                                &desc,
                                                &size);
            NSAssert1(result == noErr, @"Error getting stream info: %hd", result);
            
            //printf("r: "); desc.Print();
            
            memset (&desc, 0, sizeof (desc));
            
            // Make modifications to the CAStreamBasicDescription
            // We're going to use 16 bit Signed Ints because they're easier to deal with
            // The Mixer unit will accept either 16 bit signed integers or
            // 32 bit 8.24 fixed point integers.
            desc.mSampleRate = defaultSampleRate; // set sample rate
            desc.mFormatID = kAudioFormatLinearPCM;
            desc.mFormatFlags      = kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved;
            //kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
            desc.mBitsPerChannel = sizeof(float) * 8; //sizeof(SInt16) * 8; // AudioSampleType == 16 bit signed ints
            desc.mChannelsPerFrame = 2;
            desc.mFramesPerPacket = 1; // PCM, no packets
            desc.mBytesPerFrame = desc.mBitsPerChannel / 8; //( desc.mBitsPerChannel / 8 ) * desc.mChannelsPerFrame;
            desc.mBytesPerPacket = desc.mBytesPerFrame; //PCM, no packetization //desc.mBytesPerFrame * desc.mFramesPerPacket;
            
            //FillOutASBDForLPCM(desc, defaultSampleRate, 2, 32, 32, true, false, true);
            //CAStreamBasicDescription desc2(defaultSampleRate, 2, CAStreamBasicDescription::kPCMFormatFloat32, false);
            //printf("s: "); desc2.Print();
            
            AudioStreamBasicDescription desc2;
            
            // Apply the modified CAStreamBasicDescription to the mixer input bus
            result = AudioUnitSetProperty( audioUnit,
                                          kAudioUnitProperty_StreamFormat,
                                          scope,
                                          bus,
                                          &desc2,
                                          sizeof(desc));
            

            NSAssert1(result == noErr, @"Error setting stream format: %hd", result);

            
        }

    }
 */

    /*
    - (void) setStreamFormatFromBus : (UInt32) busIni toBus: (UInt32) busEnd forInput:(bool) isInput {
        [BaseAudioModule setStreamFormatFromBus:busIni toBus:busEnd forInput:isInput onUnit:[self getAudioUnit] ];
        
    }
     */



@end
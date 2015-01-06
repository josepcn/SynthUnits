//
//  Oscillator.m
//  CoreAudioTest
//
//  Created by Josep on 6/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oscillator.h"



double signum(double n)
{
    return (n < 0.0) ? -1.0 : 1.0;
}

double getWaveValueOnT( WaveType type, double t )
{
    double val = 0.0;
    
    if( type == kWaveSine ){
        val = sin(t);
    }
    else if( type == kWaveSaw ){
        t = t / 2.0 * M_PI;
        val = 2.0 * (t - floor(t)) - 1.0;
    }
    else if( type == kWaveSquare ){
        val = signum(sin(t));
    }
    else if (type == kWaveTriangle ){
        t = t / 2.0 * M_PI;
        val = fabs(4.0 * (t-floor(t+0.5)))-1;
    }
    
    return val;
}

double getWaveValueOnPhase( WaveType type, double phase )
{
    //http://en.wikibooks.org/wiki/Sound_Synthesis_Theory/Oscillators_and_Wavetables
    
    double res = 0.0;
    
    if( type == kWaveSine ){
        res = sin(phase);
    }
    else if( type == kWaveSaw ){
        res = 1 - (1 / M_PI * phase);
    }
    else if( type == kWaveSquare ){
        if( phase < M_PI )
            res = 1;
        else
            res = -1;
    }
    else if (type == kWaveTriangle ){
        if( phase < M_PI )
            res = -1 + (2 / M_PI) * phase;
        else
            res = 3 - (2 / M_PI) * phase;
    }
    return res;
}


OSStatus OscillatorRenderFunction2(
                                  void *inRefCon,
                                  AudioUnitRenderActionFlags *ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData)

{
    Oscillator * generator = (__bridge Oscillator*) inRefCon;
    double f = generator.frequency;
    double amp = generator.amplitude;
    double sampleRate = generator.sampleRate;
    double radiansPerStep = 2.0 * M_PI * f / sampleRate;
    double phase = generator.currentTime;
    
    // we expect stereo PCM non-interleaved
    assert( ioData->mNumberBuffers == 2 && "Render Callback: Wrong format" );
    
    Float32 * buffer0 = (Float32 *)ioData->mBuffers[0].mData;
    Float32 * buffer1 = (Float32 *)ioData->mBuffers[1].mData;
        
    // Generate the samples
    for( UInt32 frame = 0; frame < inNumberFrames; frame++ ) {
        if( [generator isEnabled] ){
            Float32 floatVal = getWaveValueOnPhase(generator.wave, phase) * amp; // -1 , +1

            buffer0[frame] = floatVal;
            buffer1[frame] = floatVal;
        }
        else{
            buffer0[frame] = 0;
            buffer1[frame] = 0;
        }

        phase += radiansPerStep;
        if( phase > 2 * M_PI ){
            phase = phase - 2 * M_PI;
        }
    }
    
    generator.currentTime = phase;
    
    return noErr;
}

@implementation Oscillator{
    Boolean _enabled;
}


- (id) init {
    self = [super initConnectableWithNumUnits:2];
    _enabled = false;
    _currentTime = 0.0;
    _frequency = defaultFrequency;
    _sampleRate = defaultSampleRate;
    _amplitude = defaultAmplitude;
    _wave = kWaveSine;
    [self create];
    return self;
}


- (void) create{
    
    AudioComponentDescription generatorDescription;
    generatorDescription.componentType = kAudioUnitType_Output;
    generatorDescription.componentSubType = kAudioUnitSubType_GenericOutput;
    generatorDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    generatorDescription.componentFlags = 0;
    generatorDescription.componentFlagsMask = 0;
    
    AudioComponent generatorComponent = AudioComponentFindNext(NULL, &generatorDescription);
    NSAssert(generatorComponent, @"Can't find a generator");
    
    OSErr err = AudioComponentInstanceNew(generatorComponent, &(audioUnits[0]));
    NSAssert1(audioUnits[0], @"Error creating generator unit: %hd", err);
    

    
    // Set our tone rendering function on the unit
    AURenderCallbackStruct input;
    input.inputProc = OscillatorRenderFunction2;
    input.inputProcRefCon = (__bridge void*) self;
    err = AudioUnitSetProperty((audioUnits[0]),
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
    NSAssert1(err == noErr, @"Error setting property render callback on generator: %hd", err);
    
    
    //[BaseAudioModule setStreamFormatFromBus:0 toBus:0 forInput:true onUnit:audioUnits[0]];
    //[self setStreamFormatFromBus:0 toBus:0 forInput:false];
    
    
    // Unit 2 splitter, so we have multiple outputs
    AudioComponentDescription splitterDescription;
    splitterDescription.componentType = kAudioUnitType_FormatConverter;
    splitterDescription.componentSubType = kAudioUnitSubType_Splitter;
    splitterDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    splitterDescription.componentFlags = 0;
    splitterDescription.componentFlagsMask = 0;
    
    AudioComponent splitterComponent = AudioComponentFindNext(NULL, &splitterDescription);
    NSAssert(generatorComponent, @"Can't find a splitter");
    
    err = AudioComponentInstanceNew(splitterComponent, &(audioUnits[1]));
    NSAssert1(audioUnits[1], @"Error creating splitter unit: %hd", err);

    
    // connect generator unit with splitter
    AudioUnitConnection connection;
    connection.sourceAudioUnit = audioUnits[0]; // the generator's output1
    connection.sourceOutputNumber = 0;
    connection.destInputNumber = 0;
    
    err = AudioUnitSetProperty(audioUnits[1],
                                          kAudioUnitProperty_MakeConnection, kAudioUnitScope_Input, 0,
                                          &connection, sizeof(connection));
    NSAssert1(err == noErr, @"Error connectin generator and splitter: %hd", err);


}



@end



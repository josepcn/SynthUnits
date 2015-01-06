//
//  Oscillator.h
//  CoreAudioTest
//
//  Created by Josep on 6/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#ifndef CoreAudioTest_Oscillator_h
#define CoreAudioTest_Oscillator_h

#import "ConnectableModule.h"

typedef enum Wave_t : NSUInteger {
    kWaveSine  = 0,
    kWaveSaw = 1,
    kWaveSquare = 2,
    kWaveTriangle = 2
} WaveType;



@interface Oscillator : ConnectableAudioModule

@property (nonatomic) double frequency;
@property (nonatomic) int sampleRate;
@property (nonatomic) double currentTime;
@property (nonatomic) double amplitude;
@property (nonatomic) WaveType wave;

- (id) init;

@end

#endif

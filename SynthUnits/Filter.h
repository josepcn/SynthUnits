//
//  Filter.h
//  CoreAudioTest
//
//  Created by Josep on 13/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#ifndef CoreAudioTest_Filter_h
#define CoreAudioTest_Filter_h

#import "ConnectableModule.h"

typedef enum Filter_t : NSUInteger {
    kLowPass  = 0,
    kHighPass = 1,
    kBandPass = 2
} FilterType;


@interface Filter : ConnectableAudioModule

@property (nonatomic) double lowCutOffFreq;
@property (nonatomic) double highCutOffFreq;

-(id) init;
-(id) initWithType : (FilterType) type;

-(void) setEnabled : (bool) enabled;

-(void) setLowCutOffFreq : (double)lowCutOffFreq;
-(void) setHighCutOffFreq: (double)highCutOffFreq;


@end

#endif

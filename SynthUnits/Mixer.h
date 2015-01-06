//
//  MIxer.h
//  CoreAudioTest
//
//  Created by Josep on 16/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#ifndef CoreAudioTest_MIxer_h
#define CoreAudioTest_MIxer_h

#import "ConnectableModule.h"

@interface Mixer : ConnectableAudioModule{
}


- (id) init;
- (void) setInputVolume: (float)volume onBus: (int)bus;

@end

#endif

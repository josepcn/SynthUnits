//
//  ConnectableModule.h
//  CoreAudioTest
//
//  Created by Josep on 30/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#ifndef CoreAudioTest_ConnectableModule_h
#define CoreAudioTest_ConnectableModule_h

#import "BaseAudioModule.h"

@interface ConnectableAudioModule : BaseAudioModule{
    
}

- (id) initConnectableWithNumUnits : (int) numUnits;
- (void) connectTo: (BaseAudioModule*) module FromBus: (uint)outBus ToBus: (uint)inBus;

@end

#endif

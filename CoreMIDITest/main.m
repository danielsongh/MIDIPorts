//
//  main.m
//  CoreMIDITest
//
//  Created by Daniel Song on 3/23/16.
//  Copyright © 2016 Daniel Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

void playPacketListOnAllDevices (MIDIPortRef midiout,
                                const MIDIPacketList* pktlist);


void myReadProc                 (const MIDIPacketList *packetList,
                                 void* readProcRefCon,
                                 void* srcConnRefCon);

MIDIPortRef gMidiout;



int main(int argc, const char * argv[]) {
    @autoreleasepool {
    
        
        MIDIClientRef midiclient;
        MIDIPortRef   midiin;
        OSStatus status;
        if ((status = MIDIClientCreate(CFSTR("TeStInG"), NULL, NULL, &midiclient))) {
            printf("Error trying to create MIDI Client structure: %d\n", status);
            printf("%s\n", GetMacOSStatusErrorString(status));
            exit(status);
        }
        if ((status = MIDIInputPortCreate(midiclient, CFSTR("InPuT"), myReadProc,
                                         NULL, &midiin))) {
            printf("Error trying to create MIDI output port: %d\n", status);
            printf("%s\n", GetMacOSStatusErrorString(status));
            exit(status);
        }
        if ((status = MIDIOutputPortCreate(midiclient, CFSTR("OuTpUt"), &gMidiout))) {
            printf("Error trying to create MIDI output port: %d\n", status);
            printf("%s\n", GetMacOSStatusErrorString(status));
            exit(status);
        }
        
        ItemCount nSrcs = MIDIGetNumberOfSources();
        ItemCount iSrc;
        for (iSrc=0; iSrc<nSrcs; iSrc++) {
            MIDIEndpointRef src = MIDIGetSource(iSrc);
            MIDIPortConnectSource(midiin, src, NULL);
        }
        
        CFRunLoopRef runLoop;
        runLoop = CFRunLoopGetCurrent();
        CFRunLoopRun();
        
        
        
        
    }
    return 0;
}

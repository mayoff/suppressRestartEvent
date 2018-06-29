#import <Foundation/Foundation.h>
#import <AppKit/NSEvent.h>

CGEventRef tapCallback(CGEventTapProxy proxy, CGEventType eventType, CGEventRef cgEvent, void *refcon) {
    // NX_SYSDEFINED subtype field is 0x53.
    if (eventType == NX_SYSDEFINED && CGEventGetIntegerValueField(cgEvent, 0x53) == NX_SUBTYPE_RESTART_EVENT) {
        printf("suppressing event\n");
        return nil;
    }
    return cgEvent;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CGEventMask mask = CGEventMaskBit(NX_SYSDEFINED);
        CFMachPortRef tap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, mask, tapCallback, nil);
        CFRunLoopSourceRef source = CFMachPortCreateRunLoopSource(nil, tap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
        CGEventTapEnable(tap, true);
        CFRunLoopRun();
    }
    return 0;
}

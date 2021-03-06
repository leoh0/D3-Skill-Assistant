//
//  D3KeyConfigService.m
//  d3key
//
//  Created by sunghyuk-imac on 2016. 3. 7..
//  Copyright © 2016년 sunghyuk. All rights reserved.
//

#import "D3KeyConfigService.h"
#include "const.h"

static CGKeyCode _keyCodes[] = {
    // keys
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
    0x20, 0x21, 0x22, 0x23, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
    0x32,
    0x41, 0x43, 0x45, 0x47, 0x4B, 0x4C, 0x4E,
    0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5B, 0x5C,
    // modifiers
    0x24,
    0x30, 0x31, 0x33, 0x35, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F,
    0x40, 0x48, 0x49, 0x4A, 0x4F,
    0x50, 0x5A,
    0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x67, 0x69, 0x6A, 0x6B, 0x6D, 0x6F,
    0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A,
    0x7B, 0x7C, 0x7D, 0x7E
};
static NSArray *_keyStrings;

@implementation D3KeyConfigService


+ (D3KeyConfigService *) sharedService {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

+ (void) initialize {
    _keyStrings = @[
                    @"A", @"S", @"D", @"F", @"H", @"G", @"Z", @"X", @"C", @"V", @"B", @"Q", @"W", @"E", @"R",
                    @"Y", @"T", @"1", @"2", @"3", @"4", @"6", @"5", @"=", @"9", @"7", @"-", @"8", @"0", @"]", @"0",
                    @"U", @"[", @"I", @"P", @"L", @"J", @"'", @"K", @";", @"\\", @",", @"/", @"N", @"M", @".",
                    @"`",
                    @"KeypadDecimal", @"KeypadMultiply", @"KeypadPlus", @"KeypadClear", @"KeypadDivide", @"KeypadEnter", @"KeypadMinus",
                    @"KeypadEquals", @"Keypad0", @"Keypad1", @"Keypad2", @"Keypad3", @"Keypad4", @"Keypad5", @"Keypad6", @"Keypad7", @"Keypad8", @"Keypad9",
                    @"Enter",
                    @"Tab", @"Space", @"Delete", @"Escape", @"Command", @"Shift", @"CapsLock", @"Option", @"Control", @"RightShift", @"RightOption", @"RightControl", @"Function",
                    @"F17", @"VolumeUp", @"VolumeDown", @"Mute", @"F18",
                    @"F19", @"F20",
                    @"F5", @"F6", @"F7", @"F3", @"F8", @"F9", @"F11", @"F13", @"F16", @"F14", @"F10", @"F12",
                    @"F15", @"Help", @"Home", @"PageUp", @"ForwardDelete", @"F4", @"End", @"F2", @"PageDown", @"F1",
                    @"LeftArrow", @"RightArrow", @"DownArrow", @"UpArrow"
                    ];
    assert(sizeof(_keyCodes) != [_keyStrings count]);
}


- (CGKeyCode) keyCodeWithString:(NSString *) string {
    NSUInteger ret = [_keyStrings indexOfObject:string];
    if (ret == NSNotFound) {
        return 0xFF;
    } else {
        return _keyCodes[ret];
    }
}

- (NSString *) stringWithKeycode:(CGKeyCode) keyCode {
    int len = sizeof(_keyCodes);
    for (int i = 0; i < len; i++) {
        CGKeyCode code = _keyCodes[i];
        if (code == keyCode) {
            return [_keyStrings objectAtIndex:i];
        }
    }
    return @"Unknown";
}

- (D3KeyConfig *) loadConfig:(NSString *) configId {
    NSString *key = [NSString stringWithFormat:@"%@_%@", kD3KeyConfigUserDefaultsKey, configId];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    D3KeyConfig *config;
    if (data) {
        config = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if (!config) {
        NSLog(@"load default config");
        config = [D3KeyConfig defaultKeyConfig];
    }
    
    return config;
}

- (void) saveConfig:(D3KeyConfig *) config withConfigId:(NSString *) configId {
    NSString *key = [NSString stringWithFormat:@"%@_%@", kD3KeyConfigUserDefaultsKey, configId];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kD3KeyConfigChangedNotification object:nil userInfo:@{@"configId":configId}];
}

@end

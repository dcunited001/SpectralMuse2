//
//  LibMuse.m
//  SpectralMuse
//
//  Created by David Conner on 2/28/16.
//  Copyright © 2016 Spectra. All rights reserved.
//

#import "LibMuse.h"

@implementation LibMuse : NSObject

+ (IXNMuseManager *)getSharedManager {
    return [IXNMuseManager sharedManager];
}

@end


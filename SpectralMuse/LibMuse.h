//
//  LibMuse.h
//  SpectralMuse
//
//  Created by David Conner on 2/28/16.
//  Copyright © 2016 Spectra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Muse.h"

@interface LibMuse : NSObject

+ (IXNMuseManager *)getSharedManager;

@end


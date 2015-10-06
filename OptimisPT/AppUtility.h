//
//  AppUtility.h
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtility : NSObject

+ (void)getDataFrom:(NSString *)url completion:(void (^)(NSDictionary*, NSError*))completion;

@end

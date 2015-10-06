//
//  AppUtility.m
//  OptimisPT
//
//  Created by Tim on 10/6/15.
//  Copyright © 2015 TimLiu. All rights reserved.
//

#import "AppUtility.h"

@implementation AppUtility

+ (void)getDataFrom:(NSString *)url completion:(void (^)(NSDictionary*, NSError*))completion
{
    NSMutableURLRequest* request;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error)
         {
             if (completion)
                 completion(nil, error);
         }
         else
         {
             NSDictionary* dictData;
             @try {
                 dictData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableLeaves
                                                              error:nil];
             }
             @catch (NSException *exception) {
                 if (completion)
                     completion(nil, error);
                 
             }
             
             if (completion)
                 completion(dictData, nil);
         }
     }];
    
}

@end

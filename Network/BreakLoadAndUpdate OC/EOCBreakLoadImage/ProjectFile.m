//
//  ProjectFile.m
//  EOCBreakLoadImage
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ProjectFile.h"



NSString *FilePathInTemp(NSString* fileName){
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
}

NSString *FilePathInDocument(NSString* fileName){
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return  [docPath stringByAppendingPathComponent:fileName];
    
}



@implementation ProjectFile

@end

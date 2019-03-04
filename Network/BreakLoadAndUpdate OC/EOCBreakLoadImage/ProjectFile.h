//
//  ProjectFile.h
//  EOCBreakLoadImage
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://www.8pmedu.com/files/system/2017/06-13/225247f9edb5180454.jpg
#define ImageURL @"http://www.8pmedu.com/files/system/2017/06-13/225247f9edb5180454.jpg"


NSString *FilePathInDocument(NSString* fileName);
NSString *FilePathInTemp(NSString* fileName);



@interface ProjectFile : NSObject

@end



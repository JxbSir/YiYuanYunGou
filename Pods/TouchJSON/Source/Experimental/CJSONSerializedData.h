//
//  CJSONSerializedData.h
//  TouchJSON
//
//  Created by Jonathan Wight on 10/31/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CJSONSerializable <NSObject>
@property (readonly, nonatomic, strong) NSData *serializedJSONData;
@end

#pragma mark -

@interface CJSONSerializedData : NSObject <CJSONSerializable> {
    NSData *data;
}

@property (readonly, nonatomic, strong) NSData *data;

- (id)initWithData:(NSData *)inData;

@end

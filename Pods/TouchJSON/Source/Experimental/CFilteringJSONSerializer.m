//
//  CFilteringJSONSerializer.m
//  TouchJSON
//
//  Created by Jonathan Wight on 06/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CFilteringJSONSerializer.h"

@implementation CFilteringJSONSerializer

@synthesize tests;
@synthesize convertersByName;

- (id)init
	{
    if ((self = [super init]) != NULL)
		{
        tests = [[NSSet alloc] init];
        convertersByName = [[NSDictionary alloc] init];
    	}
    return(self);
	}

- (NSData *)serializeObject:(id)inObject error:(NSError **)outError
    {
    NSData *theData = NULL;
    for (JSONConversionTest theTest in self.tests)
        {
        NSString *theName = theTest(inObject);
        if (theName != NULL)
            {
            id theObject = NULL;
            JSONConversionConverter theConverter = [self.convertersByName objectForKey:theName];
            if (theConverter)
                {
                theObject = theConverter(inObject);
                }
                
            if (theObject)
                {
                if ([theObject isKindOfClass:[NSData class]])
                    {
                    theData = theObject;
                    break;
                    }
                else
                    {
                    NSError *theError = NULL;
                    theData = [super serializeObject:theObject error:&theError];
                    if (theData != NULL)
                        {
                        break;
                        }
                    }
                }
            }
        }
        
    if (theData == NULL)
        {
        theData = [super serializeObject:inObject error:outError];
        }
        
    return(theData);
    }

- (void)addTest:(JSONConversionTest)inTest
    {
    inTest = [inTest copy];
    NSSet *theTests = [self.tests setByAddingObject:inTest];
    self.tests = theTests;
    }
    
- (void)addConverter:(JSONConversionConverter)inConverter forName:(NSString *)inName
    {
    NSMutableDictionary *theConvertersByName = [self.convertersByName mutableCopy];

    inConverter = [inConverter copy];
    [theConvertersByName setObject:inConverter forKey:inName];
    self.convertersByName = theConvertersByName;
    }
    

@end

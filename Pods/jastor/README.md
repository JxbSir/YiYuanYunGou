Jastor
===

Jastor is an Objective-C base class that is initialized with a dictionary (probably from your JSON response), and assigns dictionary values to all its (derived class's) typed @properties.

It supports nested types, arrays, NSString, NSNumber, NSDate and more.

Jastor is NOT a JSON parser. For that, you have [JSONKit](https://github.com/johnezang/JSONKit), [yajl](https://github.com/gabriel/yajl-objc) and many others.

The name sounds like **JSON to Object**er. Or something.


**Upgrade from previous version:**

Add `dealloc` mehtods to your models and nillify your peoperties. Automattic `dealloc` is no longer done by Jastor.

Support
---
Need help with getting Jastor up and running? Got a time-consuming problem you want to get solved quickly?  
Get [Jastor support on CodersClan](http://codersclan.net/?repo_id=327).

<p><a href="http://codersclan.net/?repo_id=327"><img src="http://www.codersclan.net/gs_button/?repo_id=327" width="200" /></a></p>


Examples
---

You have the following JSON:

```json
{
	"name": "Foo",
	"amount": 13
}
```

and the following class:

```objc
@interface Product
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *amount;
@end

@implementation Product
@synthesize name, amount;

- (void)dealloc {
	self.name = nil;
	self.amount = nil;
	
	[super dealloc];
}
@end
```

with Jastor, you can just inherit from `Jastor` class, and use `initWithDictionary:`

```objc
// Product.h
@interface Product : Jastor
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *amount;
@end

// Product.m
@implementation Product
@synthesize name, amount;

- (void)dealloc {
	self.name = nil;
	self.amount = nil;
	
	[super dealloc];
}
@end

// Some other code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.amount // => 13
```

Nested Objects
---
Jastor also converts nested objects to their destination type:

```js
// JSON
{
	"name": "Foo",
	"category": {
		"name": "Bar Category"
	}
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jastor
@property (nonatomic, copy) NSString *name;
@end

// ProductCategory.m
@implementation ProductCategory
@synthesize name;

- (void)dealloc {
	self.name = nil;
	
	[super dealloc];
}
@end

// Product.h
@interface Product : Jastor
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) ProductCategory *category;
@end

// Product.m
@implementation Product
@synthesize name, category;

- (void)dealloc {
	self.name = nil;
	self.category = nil;
	
	[super dealloc];
}
@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.category // => <ProductCategory>
product.category.name // => Bar Category
```

Arrays
---
Having fun so far?

Jastor also supports arrays of a certain type:

```js
// JSON
{
	"name": "Foo",
	"categories": [
		{ "name": "Bar Category 1" },
		{ "name": "Bar Category 2" },
		{ "name": "Bar Category 3" }
	]
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jastor
@property (nonatomic, copy) NSString *name;
@end

// ProductCategory.m
@implementation ProductCategory
@synthesize name;

- (void)dealloc {
	self.name = nil;
	
	[super dealloc];
}
@end

// Product.h
@interface Product : Jastor
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *categories;
@end

// Product.m
@implementation Product
@synthesize name, categories;

+ (Class)categories_class {
	return [ProductCategory class];
}

- (void)dealloc {
	self.name = nil;
	self.categories = nil;
	
	[super dealloc];
}
@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.categories // => <NSArray>
[product.categories count] // => 3
[product.categories objectAtIndex:1] // => <ProductCategory>
[[product.categories objectAtIndex:1] name] // => Bar Category 2
```

Notice the declaration of 

```objc
+ (Class)categories_class {
	return [ProductCategory class];
}
```

it tells Jastor what class of items the array holds.


Nested + Arrays = Trees
---
Jastor can handle trees of data:

```js
// JSON
{
	"name": "1",
	"children": [
		{ "name": "1.1" },
		{ "name": "1.2",
		  children: [
			{ "name": "1.2.1",
			  children: [
				{ "name": "1.2.1.1" },
				{ "name": "1.2.1.2" },
			  ]
			},
			{ "name": "1.2.2" },
		  ]
		},
		{ "name": "1.3" }
	]
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jastor
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *children;
@end

// ProductCategory.m
@implementation ProductCategory
@synthesize name, children;

+ (Class)children_class {
	return [ProductCategory class];
}

- (void)dealloc {
	self.name = nil;
	self.children = nil;
	
	[super dealloc];
}
@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
ProductCategory *category = [[ProductCategory alloc] initWithDictionary:dictionary];

// Log
category.name // => 1
category.children // => <NSArray>
[category.children count] // => 3
[category.children objectAtIndex:1] // => <ProductCategory>
[[category.categories objectAtIndex:1] name] // => 1.2

[[[category.children objectAtIndex:1] children] objectAtIndex:0] // => <ProductCategory>
[[[[category.children objectAtIndex:1] children] objectAtIndex:0] name] // => 1.2.1.2
```

How does it work?
---
Runtime API. The class's properties are read in runtime and assigns all values from dictionary to these properties with `NSObject setValue:forKey:`. For Dictionaries, Jastor instantiates a new class, based on the property type, and issues another `initWithDictionary`. Arrays are only a list of items such as strings (which are not converted) or dictionaries (which are treated the same as other dictionaries).

Installation
---
Just copy Jastor.m+.h and JastorRuntimeHelper.m+.h to your project, create a class, inherit, use the `initWithDictionary` and enjoy!


Testing
---

Make sure to initialize git submodules.

```bash
git submodules init
git submodules update
```

In Xcode, hit CMD+U under iPhone simulator scheme.

REALLY Good to know
---

**What about properties that are reserved words?**

As for now, `id` is converted to `objectId` automatically. Maybe someday Jastor will have ability to map server and obj-c fields.

**Jastor classes also conforms to NSCoding protocol**

So you get `initWithCoder`/`encodeWithCoder` for free.

**You can look at the tests for real samples**.

Alternatives
---

* [KVCObjectMapping](https://github.com/tuyennguyencanada/KVCObjectMapping)
* [ManagedJastor](https://github.com/patternoia/ManagedJastor) - for `NSManageObject`s
* [RestKit](http://restkit.org/)


Contributors
---

* **Elad Ossadon** [@elado](http://twitter.com/elado)
* **Yosi Taguri** [@yosit](http://github.com/yosit)

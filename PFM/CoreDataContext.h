//
//  CoreDataContext.h
//  PFM
//
//  Created by Metehan Karabiber on 09/04/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import CoreData;

@interface CoreDataContext : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype) getContext;

@end

/*
 * Copyright 2016 Resin.io
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <CoreFoundation/CoreFoundation.h>
#import <DiskArbitration/DiskArbitration.h>

DADiskRef GetWholeDisk(DADiskRef disk);
void MountCallback(DADiskRef disk, DADissenterRef dissenter, void *context);

volatile int ExitCode = EXIT_SUCCESS;

int main(int argc, const char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <disk>\n", argv[0]);
    return EXIT_FAILURE;
  }

  @autoreleasepool {
    const char *deviceName = argv[1];

    dispatch_queue_t queue = dispatch_queue_create("macmount", DISPATCH_QUEUE_SERIAL);
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, deviceName);
    DADiskRef wholeDisk = GetWholeDisk(disk);

    // Pass NULL for a "standard" mount path.
    // `kDADiskMountOptionWhole` is needed to be able to mount
    // disks containing multiple partitions with mountable filesystems.
    DADiskMount(wholeDisk, NULL, kDADiskMountOptionWhole, MountCallback, (void *)deviceName);

    DASessionSetDispatchQueue(session, queue);

    @autoreleasepool {
      CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, true);
    }

    DASessionSetDispatchQueue(session, NULL);
    CFRelease(session);
    CFRelease(disk);
    CFRelease(wholeDisk);
    session = NULL;
    disk = NULL;
    wholeDisk = NULL;
  }

  return ExitCode;
}

/**
 * Attempt to get the whole disk from a DADiskRef.
 *
 * If our disk represents `/dev/disk2s3`, then the whole disk
 * represents `/dev/disk2`.
 *
 * If the passed disk is already the whole disk, then the same
 * disk is returned.
 *
 * The caller implicitly retains the object and is responsible
 * for releasing it with `CFRelease()`.
 *
 * @private
 * @param disk The disk.
 * @return The whole disk object.
 */
DADiskRef GetWholeDisk(DADiskRef disk) {
  DADiskRef whole = DADiskCopyWholeDisk(disk);

  if (whole) {
    return whole;
  }

  return disk;
}

/**
 * The mount callback.
 *
 * This function is called when a disk is mounted, as registered
 * in `DADiskMount`, and its helpful to determine if the mount
 * operation succeeded or not, and why.
 *
 * @private
 * @param disk      The disk object.
 * @param dissenter The `DADissenter` object from the mount.
 * @param context   The context passed from the callback registration.
 */
void MountCallback(DADiskRef disk, DADissenterRef dissenter, void *context) {
	const char *mountedDisk = context;
	DAReturn status;

	if (dissenter != NULL) {
		status = DADissenterGetStatus(dissenter);
	} else {
		status = kDAReturnSuccess;
	}

	if (status == kDAReturnSuccess) {
		printf("Disk mounted successfully: %s\n", mountedDisk);
	} else if (status == kDAReturnBadArgument) {
		fprintf(stderr, "Disk not found: %s\n", mountedDisk);
	} else {
		fprintf(stderr, "An unknown error happened\n");
	}

	ExitCode = status;
}

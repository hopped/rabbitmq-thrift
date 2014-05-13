namespace java com.hopped.runner.thrift
namespace perl COM_HOPPED.Runner.Thrift

struct User {
    1: optional string nameOrAlias,
    2: optional i32 id,
    3: optional i32 birthdate,
    4: optional string totalDistanceMeters,
    5: optional string eMail,
    6: optional string firstName,
    7: optional string gender,
    8: optional i32 height,
    9: optional string lastName,
   10: optional i32 weight,
}

struct Run {
    1: optional string nameOrAlias,
    2: optional i32 id,
    3: optional i32 averageHeartRateBpm,
    4: optional double averagePace,
    5: optional double averageSpeed,
    6: optional i32 calories,
    7: optional i32 date,
    8: optional string description,
    9: optional double distanceMeters,
   10: optional double maximumSpeed,
   11: optional i32 maximumHeartRateBpm,
   12: optional i32 totalTimeSeconds,
}

struct RunList {
    1: optional list<Run> runs,
}

struct RunRequest {
    1: optional User user,
    2: optional string distance,
}

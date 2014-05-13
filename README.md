# rabbitmq-thrift

> Demonstrating the use of Apache Thrift for serialization in order
to interchange data between Perl and Java via [RabbitMQ][rabbitmq] in RPC mode. This code is based on the excellent [RPC tutorial][rpc] by RabbitMQ.


## Motivation
Since one hardly finds any examples of using [RabbitMQ][rabbitmq] in connection with [Apache Thrift][thrift] for Perl, I decided to write a small example of using RabbitMQ in [RPC mode][rpc] to interchange data serialized with Thrift between Perl and Java.

This tutorial will be part of a ''greater'' series using other data-interchange
formats such as [Google Protocol Buffers][protobuf] and [Apache Avro][avro].


## Prerequisites

> Please skip this section, if you've already installed [Gradle][gradle], [RabbitMQ][rabbitmq], [Apache Thrift][thrift], Perl including [AnyEvent][anyevent], [Net::RabbitFoot][rabbitfoot], and [DBD::Mock][mock].

It should be noted, that the following instructions assume Mac OS X to be used as an operating system. The OS X version the installation is tested on is 10.9. Please adapt the commands to satisfy your needs, if needed.


### Gradle

Download [Gradle][gradle] via the following link

```bash
https://services.gradle.org/distributions/gradle-1.12-all.zip
```

unpack, and set the desired environment variable. Please replace {username} and {path-to-gradle}:

```bash
GRADLE_HOME=/Users/{username}/{path-to-gradle}/gradle-1.12
export GRADLE_HOME
export PATH=$PATH:$GRADLE_HOME/bin
```

### RabbitMQ

The easiest way to install RabbitMQ on Mac OS X is via __Homebrew__, the ''missing
package manager for OS X''. Open a terminal, and install [Homebrew][homebrew] as follows:

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Next, install RabbitMQ (currently v3.2.4), and add the path to your $PATH variable:

```bash
brew update
brew install rabbitmq
export PATH=$PATH:/usr/local/sbin
```

Enable the management plugin (optional):

```bash
rabbitmq-plugins enable rabbitmq_management
```

Start the server:

```bash
rabbitmq-server
```

You can now browse to http://localhost:15762 in order to monitor your running RabbitMQ instance (if you previously installed the management plugin).


### Perl

I advice to install Perl via __perlbrew__. If you don't have a running installation of [perlbrew][perlbrew], then just execute the following line in your command line:

```bash
\curl -L http://install.perlbrew.pl | bash
```

Next, install a current version of Perl. It should be noted, that 5.16.0 has a bug when compiling the Protobuf definitions for Perl. Hence, you might want to use another version, e.g. 5.18.2:

```bash
perlbrew install perl-5.18.2
perlbrew switch perl-5.18.2
```

Now, we need to install some dependencies (use cpan or cpanminus):

```bash
cpanm install --notest AnyEvent
cpanm install --notest Net::RabbitFoot
cpanm install --notest DBD::Mock
```

Please note, that there are some errors while running the tests for each of the packages. Thus, we have to use the ''no test'' option.


### Apache Thrift

#### Install from scratch

Since the Perl support of Apache Thrift is minimal, I wrote a Serializer and Deserializer module for Perl in order to serialize/deserialize an Apache Thrift object into a byte array and vice versa. Both modules are included in my forked repository of Thrift. Thus, I recommend to install Apache Thrift using the following GitHub repository:

```bash
git clone git://github.com/hopped/thrift.git
```

Install Apache Thrift based on their installation instructions, which can be found [here](http://thrift.apache.org/docs/install/os_x).

Install the Perl extension as follows.


#### Installing just the Perl extension in addition to Thrift

```bash
cd  {path-to-thrift-sources}/lib/perl
perl Makefile.PL
sudo make install
```

Make sure, that you've installed the following Perl libraries: Bit::Vector and Class::Accessor.

For users that have Thrift already installed, and just missing the Perl extension: Since only two files are affected (which are further only dependent on the Perl lib), it is also possible two copy the Serializer.pm and Deserializer.pm to thrift-0.9.0/lib/perl/lib before building the Perl module.



## Installation

This section assumes that you've successfully installed RabbitMQ, Protobuf, Protobuf for Perl/XS, and that you are able to compile Protbuf definitions for Perl and Java.

First, clone the repository:

```bash
git clone git://github.com/hopped/rabbitmq-thrift.git
```

Then, generate both the Thrift binaries for Java and Perl via executing the following commands (note, that this step will be redundant in the future):

```bash
# Current directory is the project root

# Java
cd src/main/resources/java
thrift -gen java -out ../java SimpleRunner.thrift

# Perl
cd ../perl
thrift -gen perl -out ../perl SimpleRunner.thrift
```

The Java task copies all generated Java classes directly to ''src/main/java'', and the Perl task copies the created modules to ''src/main/perl''.

Finally, you can build the project using the Gradle build file:

```bash
# Current directory is the project root
gradle build
```

## Run the example

Since I don't have written a suitable Gradle task yet, you have to execute the following commands to run the default client/server scenario (ideally you can run each command in its own shell):

```bash
# Current directory is the project root

# (1) Start the RabbitMQ Server
rabbitmq-server
# (2) Start the server written in Perl
perl src/main/perl/RPCServer.pl
# (3) Run the client written in Java
gradle run
```


## Data

What data was actually interchanged? For this example, I wrote a small Thrift definition file that might be used by a running website such as [Strava](http://www.strava.com) or [SmashRun](http://www.smashrun.com) in order to store runs for users. Let's have a look at the SimpleRunner.thrift:

```thrift
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
```

## Contributing
Find a bug? Have a feature request?
Please [create](https://github.com/hopped/rabbitmq-thrift/issues) an issue.


## Authors

**Dennis Hoppe**

+ [github/hopped](https://github.com/hopped)


## Release History

| Date        | Version | Comment          |
| ----------- | ------- | ---------------- |
| 2014-05-13  | 0.1.0   | Initial release. |


## TODO

- Generate Java and Perl modules by Thrift automatically as a Gradle task during build
- Test cases


## License
Copyright 2014 Dennis Hoppe.

[MIT License](LICENSE).


[anyevent]: http://search.cpan.org/dist/AnyEvent/
[avro]: http://avro.apache.org/
[gradle]: http://www.gradle.org/
[homebrew]: http://brew.sh/
[mock]: http://search.cpan.org/~dichi/DBD-Mock-1.45/lib/DBD/Mock.pm
[perlbrew]: http://perlbrew.pl/
[perlxs]: https://code.google.com/p/protobuf-perlxs/
[protobuf]: https://code.google.com/p/protobuf/
[rabbitmq]: http://www.rabbitmq.com
[rabbitfoot]: http://search.cpan.org/~ikuta/Net-RabbitFoot-1.03/lib/Net/RabbitFoot.pm
[rpc]: http://www.rabbitmq.com/tutorials/tutorial-six-java.html
[thrift]: http://thrift.apache.org/

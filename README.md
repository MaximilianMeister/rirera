# rirera

http://github.com/MaximilianMeister/rirera

## What is rirera?

A small ruby command line tool to calculate a risk reward ratio.

![screenshot](http://ibin.co/1jv1nIeXZ8j9)

## Installation

`gem install 'rirera'`

Alternatively run directly from the git directory

## Configuration

Add your broker, and its specific commision rates to `conf/rirera.yml`

## Run

```
$ rirera -h
Options:
  --broker, -b <s>:   choose your broker
  --volume, -v <f>:   volume (amount of money)
  --target, -t <f>:   target price
  --actual, -a <f>:   actual price
    --stop, -s <f>:   stop loss
        --loop, -l:   start rirera in loop input mode (other options will be
                      discarded)
        --help, -h:   Show this message
```

# Panorama - A New Kind of Visual Debugger for Ruby

*Note: This code is still at the incredibly rough, proof-of-concept stage with no test coverage, and shouldn't be considered usable for any kind of actual real debugging yet. But if you're interested in building a new kind of debugger, I'd love some help.*

[![Build Status](https://travis-ci.org/dblock/ruby-enum.png)](https://travis-ci.org/dblock/ruby-enum)

Panorama is a web-based visual debugger that's different from most. It's primarily inspired by the ideas of Bret Victor, especially those he presented in his essay [Learnable Programming](http://worrydream.com/#!/LearnableProgramming). It uses Ruby 2.0's new [TracePoint API](http://ruby-doc.org/core-2.0/TracePoint.html). I introduced it during my talk ["Programming is Debugging, So Debug Better"](https://speakerdeck.com/yozlet/programming-is-debugging-so-debug-better) at [Open Source Bridge 2013](http://opensourcebridge.org/).

Rather than stepping through your code in progress, it gathers all the data it can and presents it after execution has finished. It shows you:
* every invocation of a Ruby method, whether in your code or someone else's
* the arguments and return value of each method invocation
* which lines were executed during that invocation
* the values of each local variable at that line

## Panorama's Actual Primary Aim

To be the debugging tool you use instead of adding `puts` statements all over your code.

This sounds like an easy goal. However, *all* the top Ruby coders I've interviewed about this (at least four of them - [see this slide](https://speakerdeck.com/yozlet/programming-is-debugging-so-debug-better?slide=59)) use `puts` as their first resort when debugging. So, can we make a better replacement?

## Current Status

Laughably poor. There's so much to be done:

* Gem packaging
* Actual tests
* Actual documentation
* Proper Sinatra app setup (using [Vegas](http://code.quirkey.com/vegas/)?)
* Colour the run lines properly
* Are we handing exceptions correctly? How about passed blocks? Anything else?
* Macros to invoke from within editors
* Link to a test runner, so the code can be re-run continually
* Bret-tastic loop value display
* Can it work using Ruby 1.9's `set_trace_func()` ?
* Some kind of thread/concurrency safety would be good - at present, it does Stupid Things With Globals
* A billion other things

## A Very Poor Screenshot

![I did warn you.](http://yozlet.github.io/panorama/images/screenshots/screenie1.png)

## Getting Started

**At present, Ruby 2.0 is required. If you need to run earlier versions of Ruby as well, I highly recommend the excellent [rbenv](http://github.com/sstephenson/rbenv/)**

* Clone the repo to a nearby ditch
* Run `bundle install`. (If you don't have `bundler` installed yet: `gem install bundler`)
* To start the webapp: `bundle exec rerun gazer.rb`
* Once you see `Listening on localhost:4567, CTRL+C to stop` , visit (http://localhost:4567) in your browser.

At present, the work is split between
* `panorama.rb` - a set of TracePoint hooks which build an in-memory profile of running code
* `gazer.rb` - a minimal Sinatra app which can invoke Panorama, then present the results as a browsable dataset

Once you have it running locally, click this for a browsable example: [http://localhost:4567/?codefile=.%2Fweb-test.rb](http://localhost:4567/?codefile=.%2Fweb-test.rb)

If you want to try using Panorama's TracePoint hooks without the web app, `cli-test.rb` is a simple example.

## What Who How?

I'm [Yoz Grahame](http://yoz.com/), and I work for [Neo Innovation](http://neo.com/).

Problems or patches? [Check the issues](https://github.com/yozlet/panorama/issues), and if it you don't see your question addressed, [add one](https://github.com/yozlet/panorama/issues/new).

If this code is remotely interesting to you, I'd love to know. Send me email (I bet you can work it out) or [tweet at me](http://twitter.com/yoz).

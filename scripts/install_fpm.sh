#!/bin/bash -x

# First lets install FPM + Pre-Reqs
yum -y install ruby rubygems ruby-devel make gcc rpm-build
gem install fpm

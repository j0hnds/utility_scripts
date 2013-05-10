utility_scripts
---------------

This project contains a number of shell scripts the provide bits of functionality.

* create_local_gems.sh - This is a utility program to allow you to create a local
  gem set (~/.gem) and package it up to use on other systems. This is particularly
  useful when the other machines have firewalls that dissallow downloading gems
  in the usual way.
* capture_shared_files - This utility script captures the set of files in the shared
  directory of a rails project that has been depoyed via capistrano.

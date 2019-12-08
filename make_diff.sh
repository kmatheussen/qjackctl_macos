#!/bin/sh

tar xvzf qjackctl-qjackctl_0_6_0.tar.gz
diff -ur qjackctl-qjackctl_0_6_0 qjackctl >qjackctl.diff
rm -fr qjackctl-qjackctl_0_6_0


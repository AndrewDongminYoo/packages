#!/bin/bash
# Copyright 2013 The Flutter Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
set -e

dart ./script/tool/bin/flutter_plugin_tools.dart custom-test \
	--packages-for-branch --log-timing

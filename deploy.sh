#!/bin/bash
flutter test
flutter build web
firebase deploy --only hosting

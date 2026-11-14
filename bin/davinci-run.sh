#!/usr/bin/env bash
distrobox enter -T -n davinci-arch -- env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /opt/resolve/bin/resolve

#!/usr/bin/env bash

# Wait for Carla to expose its nodes (up to 15 seconds)
for i in {1..15}; do
  if pw-link -o | grep -q 'Carla:output' && pw-link -i | grep -q 'Carla:input'; then
    break
  fi
  sleep 1
done

sleep 0.5

# Connect FIFINE Microphone to Carla
MIC_PORT=$(pw-link -o | grep -E 'FIFINE_Microphone.*:capture_MONO' | head -n1)
if [ -n "$MIC_PORT" ]; then
  pw-link "$MIC_PORT" Carla:input_MONO 2>/dev/null || true
fi

# Connect Carla to Virtual Mic
pw-link Carla:output_FL virtual_mic:input_FL 2>/dev/null || true
pw-link Carla:output_FR virtual_mic:input_FR 2>/dev/null || true

# Disconnect Carla from default speakers/headphones (avoid mic echo in ears)
for p in $(pw-link -l | grep -B1 'Carla:output_FL' | grep 'playback_FL' | awk '{print $1}'); do
  pw-link -d Carla:output_FL "$p" 2>/dev/null || true
done
for p in $(pw-link -l | grep -B1 'Carla:output_FR' | grep 'playback_FR' | awk '{print $1}'); do
  pw-link -d Carla:output_FR "$p" 2>/dev/null || true
done

exit 0

#!/bin/sh

base="${1##*/}"
base="${base%.*}"
cache="-fmodules-cache-path=$2"
compiled_macOS="$2/$base-macosx.air"
linked_macOS="$2/$base-macosx.metallib"
compiled_iOS="$2/$base-iphoneos.air"
linked_iOS="$2/$base-iphoneos.metallib"
compiled_tvOS="$2/$base-tvos.air"
linked_tvOS="$2/$base-tvos.metallib"
compiled_visionOS="$2/$base-visionos.air"
linked_visionOS="$2/$base-visionos.metallib"
output="$2/${base}Data.tmp"
final="$2/${base}Data.swift"

xcrun -sdk macosx metal -fcikernel "$1" -c -o "$compiled_macOS" "$cache" --target=air64-apple-macosx10.15.0 || exit $?
xcrun -sdk macosx metallib -cikernel -o "$linked_macOS" "$compiled_macOS" || exit $?

xcrun -sdk iphoneos metal -fcikernel "$1" -c -o "$compiled_iOS" "$cache" --target=air64-apple-ios13.0 || exit $?
xcrun -sdk iphoneos metallib -cikernel -o "$linked_iOS" "$compiled_iOS" || exit $?

xcrun -sdk appletvos metal -fcikernel "$1" -c -o "$compiled_tvOS" "$cache" --target=air64-apple-tvos13.0 || exit $?
xcrun -sdk appletvos metallib -cikernel -o "$linked_tvOS" "$compiled_tvOS" || exit $?

xcrun -sdk xros metal -fcikernel "$1" -c -o "$compiled_visionOS" "$cache" --target=air64-apple-xros1.0 || exit $?
xcrun -sdk xros metallib -cikernel -o "$linked_visionOS" "$compiled_visionOS" || exit $?

echo "import Foundation" > "$output"
echo "#if os(macOS) || targetEnvironment(macCatalyst)" >> "$output"

echo "let ${base}Data = Data([" >> "$output"
xxd -i "$linked_macOS" | grep -E '^[[:space:][:digit:]a-fx,]*$' >> "$output"
echo "])" >> "$output"

echo "#elseif os(iOS)" >> "$output"

echo "let ${base}Data = Data([" >> "$output"
xxd -i "$linked_iOS" | grep -E '^[[:space:][:digit:]a-fx,]*$' >> "$output"
echo "])" >> "$output"

echo "#elseif os(tvOS)" >> "$output"

echo "let ${base}Data = Data([" >> "$output"
xxd -i "$linked_tvOS" | grep -E '^[[:space:][:digit:]a-fx,]*$' >> "$output"
echo "])" >> "$output"

echo "#elseif os(visionOS)" >> "$output"

echo "let ${base}Data = Data([" >> "$output"
xxd -i "$linked_visionOS" | grep -E '^[[:space:][:digit:]a-fx,]*$' >> "$output"
echo "])" >> "$output"

echo "#else" >> "$output"
echo '#error("Unsupported platform")' >> "$output"
echo "#endif" >> "$output"

if diff -q "$output" "$final"; then
    echo Output unchanged
    rm "$output"
else
    echo Output changed
    mv -f "$output" "$final"
fi

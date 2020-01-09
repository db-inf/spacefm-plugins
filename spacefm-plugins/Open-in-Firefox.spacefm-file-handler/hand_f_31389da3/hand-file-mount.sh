#!/bin/bash

url=$(grep -i -E "^URL=" %f)
firefox "${url:4}"
